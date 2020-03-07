require 'rails_helper'

RSpec.describe '/v10/races/:race_id/orders/:order_id/complete', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:race) { FactoryGirl.create(:race) }
  let!(:ticket) { FactoryGirl.create(:ticket, race: race, status: 'selling') }
  let!(:ticket_info) { FactoryGirl.create(:ticket_info, ticket: ticket) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_extra) { FactoryGirl.create(:user_extra, user: user, status: 'passed') }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end
  let(:e_ticket_params) do
    {
        ticket_type: 'e_ticket',
        email: 'test@gmail.com',
        cert_id: user_extra.id
    }
  end
  let(:entity_ticket_params) do
    {
      ticket_type: 'entity_ticket',
      mobile: '13428725222',
      consignee: '收货人先生',
      address: '收货地址',
      cert_id: user_extra.id
    }
  end
  let(:create_order) do
    Services::Orders::CreateOrderService.call(race, ticket, user, e_ticket_params)
    user.orders.find_by_race_id(race.id)
  end
  let(:create_entity_ticket_order) do
    Services::Orders::CreateOrderService.call(race, ticket, user, entity_ticket_params)
    user.orders.find_by_race_id(race.id)
  end
  let(:other_people_order) do
    other_user = FactoryGirl.create(:user, user_uuid: 'test123_geek',
                                    user_name: 'Geek',
                                    mobile: '13655667766',
                                    email: 'test2@deshpro.com')
    user_extra = FactoryGirl.create(:user_extra, user: other_user, status: 'passed')
    params = e_ticket_params.merge(cert_id: user_extra.id)
    Services::Orders::CreateOrderService.call(race, ticket, other_user, params)
    other_user.orders.find_by_race_id(race.id)
  end

  context '确认收货订单成功' do
    it '原先状态为delivered,应改成completed' do
      order = create_order
      order.delivered!
      expect(order.status).to     eq('delivered')

      post v10_user_order_complete_index_url(user.user_uuid, order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order.reload
      expect(order.status).to eq('completed')
    end

    it '原先状态非delivered,状态不应改变' do
      order = create_order
      expect(order.status).to     eq('unpaid')

      post v10_user_order_complete_index_url(user.user_uuid, order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order.reload
      expect(order.status).to eq('unpaid')
    end
  end

  context '确认收货订单失败' do
    it '不能确认收货非本人的订单' do
      order = other_people_order
      post v10_user_order_complete_index_url(user.user_uuid, order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100006)
    end
  end
end
