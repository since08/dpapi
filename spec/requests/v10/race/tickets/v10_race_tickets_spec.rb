require 'rails_helper'

RSpec.describe '/v10/races/:race_id/tickets', :type => :request do

  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:user) { FactoryGirl.create(:user) }
  let!(:test_user) { TestUser.create(user: user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end
  let(:race) do
    FactoryGirl.create(:race)
  end
  let!(:init_tickets) do
    ticket = FactoryGirl.create(:ticket, race: race, status: 'selling')
    FactoryGirl.create(:ticket_info, ticket: ticket)
    ticket = FactoryGirl.create(:ticket, race: race, status: 'selling', role_group: 'tester')
    FactoryGirl.create(:ticket_info, ticket: ticket)
  end

  let(:race_host) do
    FactoryGirl.create(:race_host)
  end

  context '获取套票列表' do
    it '用户不是tester时只能看到everyone的组的套票' do
      get v10_race_tickets_url(race.id),
          headers: http_headers

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      tickets = json['data']['tickets']
      expect(tickets.size).to eq(1)
    end

    it '用户是tester时 可以看到所有组的套票' do
      get v10_race_tickets_url(race.id),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      tickets = json['data']['tickets']
      expect(tickets.size).to eq(2)
    end

  end
end