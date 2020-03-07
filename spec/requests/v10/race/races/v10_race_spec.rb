require 'rails_helper'

RSpec.describe 'v10_u_race_detail', :type => :request do

  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:user) { FactoryGirl.create(:user) }
  let(:race_desc) { FactoryGirl.create(:race_desc) }
  let(:followed_and_ordered_race) do
    race_desc = FactoryGirl.create(:race_desc)
    # FactoryGirl.create(:ticket_info, race_id: race_desc.race_id)
    FactoryGirl.create(:purchase_order, race: race_desc.race, user: user)
    FactoryGirl.create(:race_follow, race_id: race_desc.race_id, user_id: user.id)
    race_desc
  end
  context '当访问不存在赛事详情时' do
    it '应当返回不存在相应的数据' do
      get v10_u_race_url(0, 'nonexistent'),
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100006)
    end
  end

  context '当访问赛事详情时' do
    it '应当返回相应的数据' do
      get v10_u_race_url(0, race_desc.race_id),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      race = json['data']['race']
      expect(race['description']).to eq(race_desc.description)
      expect(race['name']).to        eq(race_desc.race.name)
      expect(race['seq_id']).to      eq(race_desc.race.seq_id)
      expect(race['logo']).to        eq(race_desc.race.logo.url(:sm))
      expect(race['big_logo']).to    eq(race_desc.race.logo.url)
      expect(race['prize']).to       eq(race_desc.race.prize)
      expect(race['location']).to    eq(race_desc.race.location)
      expect(race['begin_date']).to  eq(race_desc.race.begin_date.to_s)
      expect(race['end_date']).to    eq(race_desc.race.end_date.to_s)
      expect(race['status']).to      eq(race_desc.race.status)
      expect(race['ticket_sellable']).to  eq(race_desc.race.ticket_sellable)
      expect(race['describable']).to      eq(race_desc.race.describable)
      expect( %w(true false) ).to    include(race['followed'].to_s)
      # expect( %w(true false) ).to    include(race['ordered'].to_s)

      expect(get(race['big_logo'])).to eq(200)
    end
  end

  context '当赛事状态为未开始或进行中或已结束或已关闭' do
    it '返回的赛事状态应为 未开始' do
      race = AcFactory::AcBase.call('generate_race', status: 0)
      get v10_u_race_url(0, race.id),
          headers: http_headers

      json = JSON.parse(response.body)
      race = json['data']['race']
      expect(race['status']).to  eq('unbegin')
    end

    it '返回的赛事状态应为 进行中' do
      race = AcFactory::AcBase.call('generate_race', status: 'go_ahead')
      get v10_u_race_url(0, race.id),
          headers: http_headers

      json = JSON.parse(response.body)
      race = json['data']['race']
      expect(race['status']).to  eq('go_ahead')
    end

    it '返回的赛事状态应为 已结束' do
      race = AcFactory::AcBase.call('generate_race', status: 'ended')
      get v10_u_race_url(0, race.id),
          headers: http_headers

      json = JSON.parse(response.body)
      race = json['data']['race']
      expect(race['status']).to  eq('ended')
    end

    it '返回的赛事状态应为 已终止' do
      race = AcFactory::AcBase.call('generate_race', status: 'closed')
      get v10_u_race_url(0, race.id),
          headers: http_headers

      json = JSON.parse(response.body)
      race = json['data']['race']
      expect(race['status']).to  eq('closed')
    end
  end

  context '当用户已经购票和已关注时' do
    it '应返回已购票，已关注的状态' do
      race_desc = followed_and_ordered_race
      get v10_u_race_url(user.user_uuid, race_desc.race_id),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      race = json['data']['race']
      expect(race['followed']).to  be_truthy
      # expect(race['ordered']).to   be_truthy
      # expect(race['order_id']).to   be_truthy
    end
  end

  context '有赛事结构时' do
    it '返回的赛事结构的顺序应准确' do
      race = race_desc.race
      FactoryGirl.create(:race_blind, race: race, level: 2)
      FactoryGirl.create(:race_blind, race: race, level: 1)
      FactoryGirl.create(:race_blind, race: race, level: 1, blind_type: 1, content: 'stopping')
      get v10_u_race_url(0, race_desc.race_id),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      blinds = json['data']['blinds']
      expect(blinds.size).to eq(3)
      expect(blinds[0]['blind_type']).to eq('blind_struct')
      expect(blinds[0]['level']).to eq(1)
      expect(blinds[1]['blind_type']).to eq('blind_content')
      expect(blinds[1]['level']).to eq(1)
      expect(blinds[2]['blind_type']).to eq('blind_struct')
      expect(blinds[2]['level']).to eq(2)
    end
  end
end