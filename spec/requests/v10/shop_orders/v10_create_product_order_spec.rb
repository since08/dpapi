require 'rails_helper'

RSpec.describe '/v10/product_orders', :type => :request do
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

  def two_variants_params
    two_product = FactoryGirl.create(:product, title: '第二件商品')
    two_product.master.update(price: 88)
    order_params.merge(variants:[
                                  { id: create_product.master.id, number:1 },
                                  { id: two_product.master.id, number:1 }
                                ])
  end

  context '创建订单失败' do
    it '当用户未登录时' do
      post v10_product_orders_url,
           headers: http_headers


      expect(response).to have_http_status(805)
    end

    it '当缺少参数时' do
      post v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(1100001)
    end

    it '当variants 为空时' do
      params = order_params.merge(variants: [])
      post v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(1110004)
    end

    it '当购买数量为0时' do
      params = order_params.merge(variants: [{ id: create_product.master.id, number:0 }])
      post v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(1110004)
    end
  end

  context '创建订单成功' do
    it '应成功创建所需数据' do
      post v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: order_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      order_number = json['data']['order_number']
      order = ProductOrder.find_by(order_number: order_number)
      expect(order.status).to eq('unpaid')
      expect(order.pay_status).to eq('unpaid')
      expect(order.product_order_items.size).to eq(1)
      [:name, :mobile, :province, :city, :area, :address].each do |attr|
        expect(order.product_shipping_address.send(attr).blank?).to be_falsey
      end
    end

    it '购买成功减去相应的库存' do
      unchanged_stock = create_product.master.stock
      post v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: order_params

      expect(response).to have_http_status(200)
      stock = create_product.master.reload.stock
      expect(stock).to eq(unchanged_stock - 1)
    end

    it '购买多件商品成功' do
      post v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: two_variants_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      order_number = json['data']['order_number']
      order = ProductOrder.find_by(order_number: order_number)
      expect(order.status).to eq('unpaid')
      expect(order.product_order_items.size).to eq(2)
    end

    it '购买多件商品中有商品已经下架' do
      create_product.unpublish!
      post v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: two_variants_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      order_number = json['data']['order_number']
      order = ProductOrder.find_by(order_number: order_number)
      expect(order.status).to eq('unpaid')
      expect(order.product_order_items.size).to eq(1)
    end

    it '购买多件商品中有商品已经没有库存了' do
      create_product.master.update(stock: 0)
      post v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: two_variants_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      order_number = json['data']['order_number']
      order = ProductOrder.find_by(order_number: order_number)
      expect(order.status).to eq('unpaid')
      expect(order.product_order_items.size).to eq(1)
    end
  end
end
