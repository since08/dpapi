require 'rails_helper'

RSpec.describe '/v10/product_orders/wx_paid_result', :type => :request do
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

  context '获取微信支付结果' do
    it '当微信订单不存在时' do
      get wx_paid_result_v10_product_order_url(create_order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(1110004)
      expect(json['msg']).to eq('订单不存在')
    end


    it '当微信订单已支付时, 修改订单状态，并创建wx_bill' do
      order = create_order
      post v10_product_order_wx_pay_index_url(order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      get wx_paid_result_v10_product_order_url(order.order_number),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(0)

      order = create_order.reload
      expect(order.status).to eq('paid')
      expect(order.pay_status).to eq('paid')
      expect(order.product_wx_bills.size).to eq(1)
    end

    it '当微信订单已支付时, 重复调用接口时，应正确返回code为0' do
      order = create_order
      post v10_product_order_wx_pay_index_url(order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      get wx_paid_result_v10_product_order_url(order.order_number),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(0)


      get wx_paid_result_v10_product_order_url(order.order_number),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(0)

    end
  end
end
