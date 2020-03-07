require 'rails_helper'

RSpec.describe '/v10/u/:u_id/races', :type => :request do

  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:user) { FactoryGirl.create(:user) }
  let(:init_races) do
    20.times { FactoryGirl.create(:race) }
  end
  let(:race_host) do
    FactoryGirl.create(:race_host)
  end

  context '给定存在20条赛事，当获取10条赛事时' do
    it '应当返回10条赛事，数据格式应正常' do
      init_races
      get v10_u_races_url(0),
          headers: http_headers,
          params: { page_size: 10  }

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
        expect(race['ticket_status'].class).to eq(String)
        expect(race['ticket_sellable']).to eq(true)
        expect(race['describable']).to     eq(true)
        expect( %w(true false) ).to    include(race['followed'].to_s)
        expect( %w(true false) ).to    include(race['ordered'].to_s)
      end
    end

    it '过滤主办方' do
      10.times { FactoryGirl.create(:race, race_host: race_host) }
      init_races
      get v10_u_races_url(0),
          headers: http_headers,
          params: { host_id: race_host.id  }

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to    eq(10)
      races.each do |race|
        race = Race.find(race['race_id'])
        expect(race.race_host.id).to eq(race_host.id)
      end
    end
  end


  context '当不传参数进行访问时' do
    it '应返回当前日期以及之后的赛事' do
      init_races
      get v10_u_races_url(0), headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      races.each_with_index do |race, index|
        expect(Time.parse(race['begin_date']) >= Time.now.beginning_of_day).to be_truthy
        next if index.zero?

        first_begin_date = Time.parse(races[index - 1]['begin_date'])
        second_begin_date = Time.parse(race['begin_date'])
        expect(second_begin_date >= first_begin_date).to be_truthy
      end
    end

    it '没有今后的赛事，且没有筛选条件时，应默认拿出之前的赛事' do
      20.times do
        begin_date = Random.rand(1..9).days.ago.strftime('%Y-%m-%d')
        end_date = Random.rand(1..9).days.ago.strftime('%Y-%m-%d')
        FactoryGirl.create(:race, begin_date: begin_date, end_date: end_date)
      end

      get v10_u_races_url(0), headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to eq(20)
      races.each_with_index do |race, index|
        expect(Time.parse(race['begin_date']) < Time.now.beginning_of_day).to be_truthy
        next if index.zero?

        first_begin_date = Time.parse(races[index - 1]['begin_date'])
        second_begin_date = Time.parse(race['begin_date'])
        expect(second_begin_date >= first_begin_date).to be_truthy
      end
      first_id = json['data']['first_id']
      last_id = json['data']['last_id']
      expect(first_id).to eq(races.first['seq_id'])
      expect(last_id).to eq(races.last['seq_id'])
      expect(first_id < last_id).to be_truthy
    end

    it '没有今后的赛事，且有筛选条件时' do
      10.times do
        begin_date = Random.rand(1..9).days.ago.strftime('%Y-%m-%d')
        end_date = Random.rand(1..9).days.ago.strftime('%Y-%m-%d')
        FactoryGirl.create(:race, begin_date: begin_date, end_date: end_date)
      end

      host = race_host
      10.times do
        begin_date = Random.rand(1..9).days.ago.strftime('%Y-%m-%d')
        end_date = Random.rand(1..9).days.ago.strftime('%Y-%m-%d')
        FactoryGirl.create(:race, begin_date: begin_date, end_date: end_date, race_host: host)
      end

      get v10_u_races_url(0), headers: http_headers,
          params: { host_id: host.id }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to eq(10)
      races.each_with_index do |race, index|
        expect(Time.parse(race['begin_date']) < Time.now.beginning_of_day).to be_truthy
        next if index.zero?

        first_begin_date = Time.parse(races[index - 1]['begin_date'])
        second_begin_date = Time.parse(race['begin_date'])
        expect(second_begin_date >= first_begin_date).to be_truthy
      end
      first_id = json['data']['first_id']
      last_id = json['data']['last_id']
      expect(first_id).to eq(races.first['seq_id'])
      expect(last_id).to eq(races.last['seq_id'])
      expect(first_id < last_id).to be_truthy
    end
  end

  context '给定不存在赛事列表，当获取赛事时' do
    it '应当返回空数组' do
      get v10_u_races_url(0),
          headers: http_headers,
          params: { page_size: 20, operator: :forward, begin_date: Time.now }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size.zero?).to be_truthy
    end
  end


  context '存在一条赛事' do
    it '返回的logo路径应正确' do
      race = FactoryGirl.create(:race)
      get v10_u_races_url(0),
          headers: http_headers,
          params: { page_size: 10,
                    operator: :forward,
                    begin_date: Time.now.strftime('%Y-%m-%d') }

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races[0]['logo']).to eq(race.preview_logo)
      expect(races[0]['big_logo']).to eq(race.big_logo)
    end
  end

  context '给定存在20条赛事，当以seq_id并backward获取赛事时' do
    it '那么应race的seq_id都是小于参数的seq_id' do
      init_races
      seq_id = Race.seq_asc[10].seq_id
      get v10_u_races_url(0),
          headers: http_headers,
          params: { page_size: 10,
                    operator: :backward,
                    seq_id: seq_id }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.class).to      eq(Array)
      races.each do |race|
        expect(race['seq_id'] < seq_id).to be_truthy
      end
      first_id = json['data']['first_id']
      last_id = json['data']['last_id']
      expect(first_id).to eq(races.first['seq_id'])
      expect(last_id).to eq(races.last['seq_id'])
      expect(first_id < last_id).to be_truthy
    end

    it '过滤主办方' do
      10.times { FactoryGirl.create(:race, race_host: race_host) }
      init_races
      seq_id = Race.seq_asc[10].seq_id
      get v10_u_races_url(0),
          headers: http_headers,
          params: { host_id: race_host.id, operator: :backward, seq_id: seq_id }

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size > 0).to be_truthy
      races.each do |race|
        race = Race.find(race['race_id'])
        expect(race.race_host.id).to eq(race_host.id)
      end
    end
  end

  context '给定存在20条赛事，当以seq_id并以forward操作获取赛事时' do
    it '那么应race的seq_id都是大于参数的seq_id' do
      init_races
      seq_id = Race.seq_asc[10].seq_id
      get v10_u_races_url(0),
          headers: http_headers,
          params: { page_size: 10,
                    operator: :forward,
                    seq_id: seq_id }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.class).to      eq(Array)
      races.each do |race|
        expect(race['seq_id'] > seq_id).to be_truthy
      end
      first_id = json['data']['first_id']
      last_id = json['data']['last_id']
      expect(first_id).to eq(races.first['seq_id'])
      expect(last_id).to eq(races.last['seq_id'])
      expect(first_id < last_id).to be_truthy
    end

    it '过滤主办方' do
      10.times { FactoryGirl.create(:race, race_host: race_host) }
      init_races
      seq_id = Race.seq_asc[10].seq_id
      get v10_u_races_url(0),
          headers: http_headers,
          params: { host_id: race_host.id, operator: :forward, seq_id: seq_id }

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      races.each do |race|
        race = Race.find(race['race_id'])
        expect(race.race_host.id).to eq(race_host.id)
      end
    end
  end

  context '以date为主条件过滤赛事' do
    it '存在三条赛事, 应只过滤出二条赛事' do
      FactoryGirl.create(:race, begin_date: '2017-01-01', end_date: '2017-01-10')
      exclude_race = FactoryGirl.create(:race, begin_date: '2017-01-02', end_date: '2017-01-04')
      FactoryGirl.create(:race, begin_date: '2017-01-10', end_date: '2017-01-11')
      get v10_u_races_url(0),
          headers: http_headers,
          params: { date: '2017-01-10' }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to      eq(2)
      races.each do |race|
        expect(race['race_id'] == exclude_race.id).to be_falsey
      end
    end

    it '存在三条赛事, 过滤主办方, 只过滤出1条' do
      FactoryGirl.create(:race, begin_date: '2017-01-01', end_date: '2017-01-10', race_host: race_host)
      FactoryGirl.create(:race, begin_date: '2017-01-02', end_date: '2017-01-04')
      FactoryGirl.create(:race, begin_date: '2017-01-10', end_date: '2017-01-11')
      get v10_u_races_url(0),
          headers: http_headers,
          params: { date: '2017-01-10', host_id: race_host.id }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to      eq(1)
    end
  end

  context '应只返回主赛事' do
    it '当存在5条主赛事，5条子赛事' do
      5.times { FactoryGirl.create(:race) }
      main_race = Race.main.first
      5.times { FactoryGirl.create(:race, parent: main_race) }

      get v10_u_races_url(0),
          headers: http_headers,
          params: { page_size: 20, operator: :forward, begin_date: Time.now }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to eq(5)
      races.each do |race|
        main_race = Race.find(race['race_id'])
        expect(main_race.parent_id).to eq(0)
      end
    end
  end

  context '支持多个host过滤' do
    it '存在三条赛事, 过滤2个主办方, 只过滤出2条' do
      second_host = FactoryGirl.create(:race_host, name: 'second_host')

      FactoryGirl.create(:race, begin_date: '2017-01-01', end_date: '2017-01-10', race_host: race_host)
      FactoryGirl.create(:race, begin_date: '2017-01-02', end_date: '2017-01-04', race_host: second_host)
      FactoryGirl.create(:race, begin_date: '2017-01-10', end_date: '2017-01-11')
      get v10_u_races_url(0),
          headers: http_headers,
          params: { date: '2017-01-04', host_id: "#{race_host.id},#{second_host.id }" }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.size).to      eq(2)
    end
  end
end