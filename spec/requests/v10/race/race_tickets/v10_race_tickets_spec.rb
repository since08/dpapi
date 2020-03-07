require 'rails_helper'

RSpec.describe 'v10_race_tickets', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let!(:user) { FactoryGirl.create(:user) }
  let(:race1) do
    race = FactoryGirl.create(:race, { begin_date: Time.local(2017, 3, 9).strftime('%Y-%m-%d'),
                                       end_date: Time.local(2017, 3, 22).strftime('%Y-%m-%d') })
    race.update({ published: 1 })
    race
  end

  let(:race2) do
    race = FactoryGirl.create(:race, { begin_date: Time.local(2017, 3, 12).strftime('%Y-%m-%d'),
                                       end_date: Time.local(2017, 3, 18).strftime('%Y-%m-%d') })
    race.update({ published: 1 })
    race

  end

  let(:init_races) do
    FactoryGirl.create(:race, name: 'wpt第一场')
    FactoryGirl.create(:race, name: 'wpt第二场')
    10.times { FactoryGirl.create(:race) }
  end

  context '返回正确的数组' do
    it '无数据返回空' do
      get v10_ticket_business_index_url,
          headers: http_headers.merge(HTTP_X_DP_LANG: 'en')

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to eq(0)

      get v10_ticket_business_index_url,
          headers: http_headers.merge(HTTP_X_DP_LANG: 'zh')

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
    end

    it '无数据返回空' do
      get v10_ticket_business_index_url,
          headers: http_headers.merge(HTTP_X_DP_LANG: 'zh')

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to eq(0)
    end

    it '有数据时，应返回相应的数据' do
      init_races
      get v10_ticket_business_index_url,
          headers: http_headers,
          params: { page_size: 10 }

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to       eq(10)
      first_id = json['data']['first_id']
      last_id = json['data']['last_id']
      expect(first_id).to eq(races.first['seq_id'])
      expect(last_id).to eq(races.last['seq_id'])
      expect(first_id < last_id).to be_truthy
      races.each do |race|
        expect(race.key?('race_id')).to     be_truthy
        expect(race['name'].class).to       eq(String)
        expect(race.key?('seq_id')).to      be_truthy
        expect(race['logo'].class).to       eq(String)
        expect(race['big_logo'].class).to   eq(String)
        expect(race['prize'].class).to      eq(String)
        expect(race['location'].class).to   eq(String)
        expect(race['begin_date'].class).to eq(String)
        expect(race['end_date'].class).to   eq(String)
        expect(race['status'].class).to     eq(String)
        expect(race['ticket_sellable']).to eq(true)
        expect(race['describable']).to     eq(true)
        expect( %w(true false) ).to    include(race['followed'].to_s)
        expect( %w(true false) ).to    include(race['ordered'].to_s)
      end
    end

    it '当传递seq_id参数时，应返回相应的数据' do
      init_races
      seq_id = Race.seq_asc[3].seq_id

      get v10_ticket_business_index_url,
          headers: http_headers,
          params: { seq_id: seq_id }

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size > 0).to    be_truthy
      races.each do |race|
        expect(race['seq_id'] > seq_id).to be_truthy
      end
    end

    it '当传递keyword参数时，应返回相应的数据' do
      init_races

      get v10_ticket_business_index_url,
          headers: http_headers,
          params: { keyword: 'wpt' }

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to eq(2)
      races.each do |race|
        expect(race['ticket_sellable']).to eq(true)
      end
    end
  end
end