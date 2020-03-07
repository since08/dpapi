require 'rails_helper'

RSpec.describe 'v10_u_search_by_keyword', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:race1){
    race = FactoryGirl.create(:race, { begin_date: Time.local(2017, 3, 9).strftime('%Y-%m-%d'),
                                       end_date: Time.local(2017, 3, 22).strftime('%Y-%m-%d') })
    race.update({ published: 1 })
    race
  }

  let!(:race2){
    race = FactoryGirl.create(:race, { begin_date: Time.local(2017, 3, 12).strftime('%Y-%m-%d'),
                                       end_date: Time.local(2017, 3, 18).strftime('%Y-%m-%d') })
    race.update({ published: 1 })
    race
  }

  context '如果没有传递参数' do
    it '返回默认数据' do
      get v10_u_search_by_keyword_url(0),
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      data = json['data']['items']
      expect(data.size).to eq(2)
    end
  end

  context '传递的keyword有2条记录' do
    it 'should return code: 0 & 返回的记录条数是2' do
      get v10_u_search_by_keyword_url(0),
          headers: http_headers,
          params: { keyword: '2017APT' }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      data = json['data']['items']
      first_id = json['data']['first_id']
      expect(data.size).to eq(2)
      expect(first_id.to_i).to eq(race2.seq_id)
    end

  end

  context '应只返回主赛事' do
    it '当存在5条子赛事' do
      5.times { FactoryGirl.create(:race, name: '2017APT启航站') }
      main_race = Race.main.first
      5.times { FactoryGirl.create(:race, parent: main_race, name: '2017APT启航站') }

      get v10_u_search_by_keyword_url(0),
          headers: http_headers,
          params: { keyword: '2017APT' }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      races.each do |race|
        main_race = Race.find(race['race_id'])
        expect(main_race.parent_id).to eq(0)
      end
    end
  end

end