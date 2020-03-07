require 'rails_helper'

RSpec.describe '/v10/races/:race_id/ticket/:ticket_id/unpaid_order', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:race) { FactoryGirl.create(:race) }
  let!(:ticket) { FactoryGirl.create(:ticket, race: race, status: 'selling') }
  let!(:ticket_info) { FactoryGirl.create(:ticket_info, ticket: ticket) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_extra) { FactoryGirl.create(:user_extra, user: user, status: 'passed') }
  let(:shipping_address) { FactoryGirl.create(:shipping_address, user: user) }
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

  context '对同一票赛，用户是否有未付款的订单' do
    it '有未付款的订单，返回订单号' do
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)
      expect(json['data']['order_number'].blank?).to be_falsey
      order_number = json['data']['order_number']

      get v10_race_ticket_unpaid_order_url(race.id, ticket.id),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)
      expect(json['data']['order_number']).to eq(order_number)
    end

    it '没有则 返回空' do
      get v10_race_ticket_unpaid_order_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)
      expect(json['data']['order_number'].blank?).to be_truthy
    end

  end

end