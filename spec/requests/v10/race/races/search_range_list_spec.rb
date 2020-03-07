require 'rails_helper'

RSpec.describe 'v10_u_search_range_list', :type => :request do
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

  context '如果没有传递date参数' do
    it 'should return code: 1100001' do
      get v10_u_search_range_list_url(0),
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100001)
    end
  end

  context '传递的keyword有2条记录' do
    it 'should return code: 0 & 返回的记录条数是2' do
      get v10_u_search_range_list_url(0),
          headers: http_headers,
          params: { begin_date: '20170310', end_date: '20170319' }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
    end
  end
end