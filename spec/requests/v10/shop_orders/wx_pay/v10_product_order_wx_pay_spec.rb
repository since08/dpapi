require 'rails_helper'

RSpec.describe '/v10/product_orders/:product_order_id/wx_pay', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_extra) { FactoryGirl.create(:user_extra, user: user, status: 'passed') }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end


  let(:create_product) do
    FactoryGirl.create(:product)
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
    Services::ShopOrders::CreateOrderService.call(user, order_params)
  end

  context '使用微信支付' do
    it '获取微信预付款id' do
      order = create_order.data[:order]
      post v10_product_order_wx_pay_index_url(order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      wx_result = json['data']
      expect(wx_result['appid'].blank?).to be_falsey
      expect(wx_result['partnerid'].blank?).to be_falsey
      expect(wx_result['package'].blank?).to be_falsey
      expect(wx_result['timestamp'].blank?).to be_falsey
      expect(wx_result['prepayid'].blank?).to be_falsey
      expect(wx_result['noncestr'].blank?).to be_falsey
      expect(wx_result['sign'].blank?).to be_falsey
    end

    it '支付的金额为以单位分来计算' do
      order = create_order.data[:order]
      pay_service = Services::ShopOrders::WxPayService.new(order)
      params = pay_service.send(:pay_params)
      expect(params[:total_fee]).to eq((create_product.master.price * 100).to_i)
    end

    it '当order不存在，应提示没有该数据' do
      post v10_product_order_wx_pay_index_url('test'),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100006)
    end
  end

end
