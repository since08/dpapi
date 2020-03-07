require 'rails_helper'

RSpec.describe '/v10/u/:u_id/recent_races', :type => :request do

  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:user) { FactoryGirl.create(:user) }
  let(:init_followed_or_ordered_races) do
    first_race  = FactoryGirl.create(:race,
                                     begin_date: 3.days.ago.strftime('%Y-%m-%d'),
                                     end_date: 3.days.since.strftime('%Y-%m-%d'),
                                     status: 1)
    second_race = FactoryGirl.create(:race, begin_date: 2.days.ago.strftime('%Y-%m-%d'),)
    third_race = FactoryGirl.create(:race)
    FactoryGirl.create(:race_follow, race_id: first_race.id, user_id: user.id)
    FactoryGirl.create(:purchase_order, race: second_race, user: user)
    FactoryGirl.create(:purchase_order, race: third_race, user: user)
    FactoryGirl.create(:race_follow, race_id: third_race.id, user_id: user.id)
  end

  let(:init_recent_races) do
    9.times { FactoryGirl.create(:race) }
    FactoryGirl.create(:race,
                       begin_date: 3.days.ago.strftime('%Y-%m-%d'),
                       end_date: 3.days.since.strftime('%Y-%m-%d'),
                       status: 1)
    FactoryGirl.create(:race,
                       begin_date: 8.days.ago.strftime('%Y-%m-%d'),
                       end_date: 5.days.ago.strftime('%Y-%m-%d'))
    FactoryGirl.create(:race, status: 2)
    FactoryGirl.create(:race, status: 3)
  end

  context '给定不存在即将到来的赛事，当获取赛事时' do
    it '应当返回空数组' do
      get v10_u_recent_races_url(0),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size.zero?).to be_truthy
    end
  end

  context '给定存在10条即将到来的赛事，当获取赛事时' do
    it '应当返回最近的10条赛事' do
      init_recent_races
      get v10_u_recent_races_url(0),
           headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size).to       eq(10)
      races.each do |race|
        expect(race['name'].class).to       eq(String)
        expect(race['logo'].class).to       eq(String)
        expect(race['prize'].class).to      eq(String)
        expect(race['location'].class).to   eq(String)
        expect(race['begin_date'].class).to eq(String)
        expect(race['end_date'].class).to   eq(String)
        expect(race['status'].class).to     eq(String)
        expect(race['ticket_status'].class).to eq(String)
        expect(race['ticket_sellable']).to  eq(true)
        expect(race['describable']).to      eq(true)
        expect( %w(true false) ).to    include(race['followed'].to_s)
        expect( %w(true false) ).to    include(race['ordered'].to_s)
      end
    end
  end

  context '存在一条赛事' do
    it '返回的logo路径应正确' do
      race = FactoryGirl.create(:race)
      get v10_u_recent_races_url(0),
          headers: http_headers

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races[0]['logo']).to eq(race.preview_logo)
      expect(races[0]['big_logo']).to eq(race.big_logo)
    end
  end

  context '给定存在10条即将到来的赛事，当获取8条赛事时' do
    it '应当返回最近的8条赛事' do
      init_recent_races
      get v10_u_recent_races_url(0),
          headers: http_headers,
          params: {number: 8}

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size).to       eq(8)
    end
  end

  context '给定存在10条即将到来和1条5天前结束的赛事，当获取赛事时' do
    it '那么赛事的排序应为开始日期的正序，并结束日期都是大于或等于当天的' do
      init_recent_races
      get v10_u_recent_races_url(0),
          headers: http_headers,
          params: {number: 10}

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size).to       eq(10)
      races.each_with_index do |race, index|
        expect(Time.parse(race['end_date']) >= Time.now.beginning_of_day).to be_truthy
        next if index.zero?

        first_begin_date = Time.parse(races[index - 1]['begin_date'])
        second_begin_date = Time.parse(race['begin_date'])
        expect(second_begin_date >= first_begin_date).to be_truthy
      end
    end
  end

  context '给定存在进行中，已结束，未开始，已终止这四种状态的赛事，当获取赛事时' do
    it '那么只返回进行中与未开始状态的赛事' do
      init_recent_races
      get v10_u_recent_races_url(0),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races[0]['status']).to  eq('go_ahead')
      expect(races[1]['status']).to  eq('unbegin')
      races.each do |race|
        expect([2,3]).not_to include(race['status'])
      end
    end

  end

  context '给定存在第一条赛事已关注，第二条赛事已购票, 第三条为已关注，已购票' do
    it '那么应返回正确状态的赛事列表' do
      init_followed_or_ordered_races
      get v10_u_recent_races_url(user.user_uuid),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races[0]['followed']).to  be_truthy
      expect(races[0]['ordered']).to   be_falsey
      expect(races[1]['followed']).to  be_falsey
      expect(races[1]['ordered']).to   be_truthy
      expect(races[2]['followed']).to  be_truthy
      expect(races[2]['ordered']).to   be_truthy
    end
  end

  context '应只返回主赛事' do
    it '当存在3条主赛事，5条子赛事' do
      3.times { FactoryGirl.create(:race) }
      main_race = Race.main.first
      5.times { FactoryGirl.create(:race, parent: main_race) }

      get v10_u_recent_races_url(0),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to eq(3)
      races.each do |race|
        main_race = Race.find(race['race_id'])
        expect(main_race.parent_id).to eq(0)
      end
    end
  end
end