require 'rails_helper'

RSpec.describe '/v10/races/race_id/sub_races', type: :request do

  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:user) { FactoryGirl.create(:user) }
  let(:init_sub_races) do
    main_race = FactoryGirl.create(:race)
    5.times { FactoryGirl.create(:race, parent: main_race) }
    main_race
  end

  context '访问某个主赛的边赛列表' do
    it '应成功返回边赛列表' do
      main_race = init_sub_races
      get v10_race_sub_races_url(main_race.id), headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size).to       eq(5)
      races.each do |race|
        expect(race['race_id'].class).to    eq(Fixnum)
        expect(race['name'].class).to       eq(String)
        expect(race['prize'].class).to      eq(String)
        expect(race['ticket_price'].class).to eq(String)
        expect(race['blind'].class).to      eq(String)
        expect(race['location'].class).to   eq(String)
        expect(race['begin_date'].class).to eq(String)
        expect(race['end_date'].class).to   eq(String)
        expect(race['days'].class).to   eq(Fixnum)
        expect(race.has_key?('roy')).to     be_truthy
      end
    end

    context '当传入type 为 tradable' do
      it '应返回空列表' do
        main_race = init_sub_races
        get v10_race_sub_races_url(main_race.id), headers: http_headers,
            params: {type: 'tradable'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['code']).to eq(0)
        races = json['data']['items']
        expect(races.class).to      eq(Array)
        expect(races.size).to       eq(0)
      end

      it '不返回ticket_sellable 为false的边赛' do
        main_race = init_sub_races
        sub_race = main_race.sub_races.first
        sub_race.cancel_sell!
        FactoryGirl.create(:ticket, race: sub_race, status: 'selling')
        get v10_race_sub_races_url(main_race.id), headers: http_headers,
            params: {type: 'tradable'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['code']).to eq(0)
        races = json['data']['items']
        expect(races.class).to      eq(Array)
        expect(races.size).to       eq(0)
      end

      it '存在可购票的子赛事' do
        main_race = init_sub_races
        FactoryGirl.create(:ticket, race: main_race.sub_races.first, status: 'selling')
        FactoryGirl.create(:ticket, race: main_race.sub_races.second, status: 'unsold')
        get v10_race_sub_races_url(main_race.id), headers: http_headers,
            params: {type: 'tradable'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['code']).to eq(0)
        races = json['data']['items']
        expect(races.class).to      eq(Array)
        expect(races.size).to       eq(1)
      end
    end
  end

  context '访问指定的边赛' do
    it '应返回相应的数据' do
      main_race = init_sub_races
      sub_race = main_race.sub_races.first
      FactoryGirl.create(:race_desc, race: sub_race)
      get v10_race_sub_race_url(main_race.id, sub_race.id), headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      data = json['data']
      expect(data['race_id']).to    eq(sub_race.id)
      expect(data['name']).to       eq(sub_race.name)
      expect(data['prize']).to      eq(sub_race.prize)
      expect(data['ticket_price']).to eq(sub_race.ticket_price)
      expect(data['blind']).to      eq(sub_race.blind)
      expect(data['location']).to   eq(sub_race.location)
      expect(data['begin_date']).to eq(sub_race.begin_date.to_s)
      expect(data['end_date']).to   eq(sub_race.end_date.to_s)
      expect(data['days']).to       eq(sub_race.days)
      expect(data['roy']).to        eq(sub_race.roy)
    end
  end

  context '有赛事结构时' do
    it '返回的赛事结构的顺序应准确' do
      main_race = init_sub_races
      race = main_race.sub_races.first
      FactoryGirl.create(:race_blind, race: race, level: 2)
      FactoryGirl.create(:race_blind, race: race, level: 1)
      FactoryGirl.create(:race_blind, race: race, level: 1, blind_type: 1, content: 'stopping')
      get v10_race_sub_race_url(0, race.id),
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