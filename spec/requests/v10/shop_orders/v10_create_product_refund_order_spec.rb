require 'rails_helper'

RSpec.describe '/v10/product_orders/:product_order_id/refund', :type => :request  do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:user) { FactoryGirl.create(:user) }
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

  let(:tmp_image) do
    FactoryGirl.create(:tmp_image)
  end

  let(:refund_type) do
    FactoryGirl.create(:product_refund_type)
  end

  def error_refund_params(order)
    order.delivered!
    order_item = order.product_order_items.first
    {
        "refund_images": [
            {
                "id": tmp_image.id,
                "content": "测试"
            }
        ],
        "order_item_ids": [
            order_item.id, 123
        ],
        "memo": "测试退款",
        "product_refund_type_id": refund_type.id,
        "refund_price": 12
    }
  end

  def error_refund_params2(order)
    order.delivered!
    order_item = order.product_order_items.first
    order_item.update(seven_days_return: true)
    {
        "refund_images": [
            {
                "id": tmp_image.id,
                "content": "测试"
            }
        ],
        "order_item_ids": [
            order_item.id
        ],
        "memo": "测试退款",
        "product_refund_type_id": refund_type.id,
        "refund_price": max_price(order_item) + 0.01
    }
  end

  def error_refund_params3(order, seven_days_return = true)
    order_item = order.product_order_items.first
    order_item.update(seven_days_return: seven_days_return)
    {
        "refund_images": [
            {
                "id": tmp_image.id,
                "content": "测试"
            }
        ],
        "order_item_ids": [
            order_item.id
        ],
        "memo": "测试退款",
        "product_refund_type_id": refund_type.id,
        "refund_price": max_price(order_item)
    }
  end

  def refund_params(order, seven_days_return = true)
    order.delivered!
    order_item = order.product_order_items.first
    order_item.update(seven_days_return: seven_days_return)
    {
        "refund_images": [
            {
                "id": tmp_image.id,
                "content": "测试"
            }
        ],
        "order_item_ids": [
            order_item.id
        ],
        "memo": "测试退款",
        "product_refund_type_id": refund_type.id,
        "refund_price": max_price(order_item)
    }
  end

  def max_price(order_item)
    order_item.price * order_item.number + order_item.product_order.shipping_price
  end

  context '订单退款' do
    it '当传入的订单编号不正确' do
      post v10_product_order_refund_index_url('test'),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100006)
    end

    it '当传入的商品id有一个不存在' do
      order = create_order.data[:order]
      post v10_product_order_refund_index_url(order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: error_refund_params(order)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100006)
    end

    it '当传入的商品不支持7天退换货' do
      order = create_order.data[:order]
      post v10_product_order_refund_index_url(order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: refund_params(order, false)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1110006)
    end

    it '当传入的商品是未付款状态' do
      order = create_order.data[:order]
      post v10_product_order_refund_index_url(order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: error_refund_params3(order, false)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1110009)
    end

    it '当传入的商品价格超过商品实际价格' do
      order = create_order.data[:order]
      post v10_product_order_refund_index_url(order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: error_refund_params2(order)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1110007)
    end

    it '正常退货' do
      order = create_order.data[:order]
      post v10_product_order_refund_index_url(order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: refund_params(order)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['refund_number']).to be_truthy
      expect(json['data']['refund_type']).to be_truthy
      expect(json['data']['refund_price']).to be_truthy
      expect(json['data']['memo']).to be_truthy
      expect(json['data']['status']).to eq('open')
      order_item = json['data']['refund_order_items']
      expect(order_item[0]['refund_status']).to eq('open')
    end
  end
end