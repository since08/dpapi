require 'rails_helper'

RSpec.describe '/v10/product_orders/new', :type => :request do
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
                                  { id: two_product.master.id, number:2 }
                                ])
  end

  context '获取新订单数据失败' do
    it '当用户未登录时' do
      post new_v10_product_orders_url,
           headers: http_headers

      expect(response).to have_http_status(805)
    end

    it '当variants 为空时' do
      params = order_params.merge(variants: [])
      post new_v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(1110004)
    end

    it '当购买数量为0时' do
      params = order_params.merge(variants: [{ id: create_product.master.id, number:0 }])
      post new_v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(1110004)
    end
  end

  context '获取新订单数据成功' do
    it '返回所需数据' do
      post new_v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: order_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data'].has_key?('total_price')).to be_truthy
      expect(json['data'].has_key?('total_product_price')).to be_truthy
      expect(json['data'].has_key?('shipping_price')).to be_truthy
      expect(json['data'].has_key?('freight_free')).to be_truthy
      expect(json['data']['invalid_items'].blank?).to be_truthy
      expect(json['data']['items'].size).to eq(1)
      json['data']['items'].each do |item|
        expect(item.has_key?('number')).to be_truthy
        expect(item.has_key?('title')).to be_truthy
        expect(item.has_key?('seven_days_return')).to be_truthy
        expect(item.has_key?('variant')).to be_truthy
      end
    end

    it '购买多个商品, 价格要计算正确' do
      post new_v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: two_variants_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']['items'].size).to eq(2)
      product_price = Product.last.master.price + (Product.first.master.price * 2)
      expect(product_price.to_i).to eq(json['data']['total_product_price'].to_i)
    end

    it '购买多件商品中有商品已经下架' do
      create_product.unpublish!
      post new_v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: two_variants_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']['items'].size).to eq(1)
      expect(json['data']['invalid_items'].size).to eq(1)
    end

    it '购买多件商品中有商品已经没有库存了' do
      create_product.master.update(stock: 0)
      post new_v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: two_variants_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']['items'].size).to eq(1)
      expect(json['data']['invalid_items'].size).to eq(1)
    end

    it '没有传入地址时' do
      params = {
        variants:[{ id: create_product.master.id, number:1 }]
      }
      post new_v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']['items'].size).to eq(1)
    end

    it '商品不包邮时' do
      create_product.update(freight_free: false)
      post new_v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: order_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']['shipping_price'].to_i > 0).to be_truthy
      total_price = json['data']['total_product_price'].to_i + json['data']['shipping_price'].to_i
      expect(total_price).to eq(json['data']['total_price'].to_i)
    end

    it '购买多个商品, 商品不包邮时' do
      params = two_variants_params
      Product.all.update(freight_free: false)
      post new_v10_product_orders_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']['items'].size).to eq(2)
      product_price = Product.last.master.price + (Product.first.master.price * 2)
      expect(product_price.to_i).to eq(json['data']['total_product_price'].to_i)
      expect(json['data']['shipping_price'].to_i > 0).to be_truthy
    end
  end
end
