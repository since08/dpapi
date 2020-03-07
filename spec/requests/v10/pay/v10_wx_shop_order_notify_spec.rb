require 'rails_helper'

RSpec.describe '/pay/wx_shop_order_notify', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_extra) { FactoryGirl.create(:user_extra, user: user, status: 'passed') }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end

  let(:create_product) do
    FactoryGirl.create(:product)
  end

  def total_fee
    (create_product.master.price * 100).to_i
  end

  def order_params
    {
      variants:[{ id: create_product.master.id,
                    number:1 }],
      shipping_info:{
        name:"收货人",
        mobile:"134287222",
        address:{
          province:"广东省",
          city:"深圳市",
          area:"福田区",
          detail:"卓越世纪中心3号楼"
        }
      },
      memo:"这是一个备注"
    }
  end

  let(:create_order) do
    Services::ShopOrders::CreateOrderService.call(user, order_params).data[:order]
  end

  let(:notify_params) do
    {
      appid: "wx0a27fb1118713d94",
      bank_type: "ICBC_CREDIT",
      cash_fee: "101",
      fee_type: "CNY",
      is_subscribe: "N",
      mch_id: "1486119672",
      nonce_str: "90870761493e420e9955a35be5dbd5e1",
      openid: "ogaya0xV4qnFvZOWCHNrLmdQwe9w",
      out_trade_no: create_order.order_number,
      result_code: "SUCCESS",
      return_code: "SUCCESS",
      time_end: "20171024171839",
      total_fee: total_fee,
      trade_type: "APP",
      transaction_id: "4200000022201710240047966428"
    }
  end

  let(:notify_xml) do
    generate_sign_params(notify_params).to_xml(root: 'xml')
  end

  let(:error_sign_notify_xml) do
    generate_sign_params(notify_params).merge(sign: 'error').to_xml(root: 'xml')
  end

  let(:error_price_notify_xml) do
    generate_sign_params(notify_params.merge(total_fee: '8888')).to_xml(root: 'xml')
  end

  def generate_sign_params(params)
    params = params.dup
    if WxPay.sandbox_mode?
      params = params.merge(:key => WxPay.sandbox_key)
    end
    sign = WxPay::Sign.generate(params)
    params.merge(sign: sign)
  end

  context '使用微信异步回调通知' do
    it '成功通知，修改订单状态' do
      post v10_pay_wx_shop_order_notify_index_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: notify_xml

      expect(response).to have_http_status(200)
      res_xml = Hash.from_xml(response.body)
      expect(res_xml['xml']['return_code']).to eq('SUCCESS')
      expect(res_xml['xml']['return_msg']).to eq('OK')

      order = create_order.reload
      expect(order.status).to eq('paid')
      expect(order.pay_status).to eq('paid')
      expect(order.product_wx_bills.size).to eq(1)
    end

    it '验证签名失败，返回错误信息' do
      post v10_pay_wx_shop_order_notify_index_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: error_sign_notify_xml

      expect(response).to have_http_status(200)
      res_xml = Hash.from_xml(response.body)
      expect(res_xml['xml']['return_code']).to eq('FAIL')
      expect(res_xml['xml']['return_msg']).to eq('验证签名失败')

      order = create_order.reload
      expect(order.status).to eq('unpaid')
      expect(order.pay_status).to eq('unpaid')
    end

    it '支付金额与订单不匹配，返回错误信息，需记录notify' do
      post v10_pay_wx_shop_order_notify_index_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: error_price_notify_xml

      expect(response).to have_http_status(200)
      res_xml = Hash.from_xml(response.body)
      expect(res_xml['xml']['return_code']).to eq('FAIL')
      expect(res_xml['xml']['return_msg']).to eq('订单金额不匹配')

      order = create_order.reload
      expect(order.status).to eq('unpaid')
      expect(order.pay_status).to eq('unpaid')
    end
  end

end
