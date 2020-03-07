require 'rails_helper'

RSpec.describe '/v10/race_hosts', type: :request do

  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let(:init_hosts) do
    10.times { FactoryGirl.create(:race_host) }
  end

  context '获取赛事主办方的列表' do
    it '返回空数据' do
      get v10_race_hosts_url, headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      race_hosts = json['data']['race_hosts']
      expect(race_hosts.class).to      eq(Array)
      expect(race_hosts.size).to       eq(0)
    end

    it '返回正确有数据的列表' do
      init_hosts
      get v10_race_hosts_url, headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      race_hosts = json['data']['race_hosts']
      expect(race_hosts.class).to      eq(Array)
      expect(race_hosts.size).to       eq(10)
      race_hosts.each do |host|
        expect(host['id'].class).to    eq(Fixnum)
        expect(host['name'].class).to  eq(String)
      end
    end
  end
end