require 'rails_helper'

RSpec.describe '/v10/headlines', :type => :request do
  let(:headlines) do
    race = FactoryGirl.create(:race)
    info = FactoryGirl.create(:info)
    FactoryGirl.create(:headline, source: race, published: false)
    FactoryGirl.create(:headline, source: race, published: true, position: 5)
    FactoryGirl.create(:headline, source: race, published: true, position: 1)
    FactoryGirl.create(:headline, source: info, published: true, position: 2)
    FactoryGirl.create(:headline, source: info, published: true, position: 2)
  end
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }


  context '获取headline列表' do
    it '应过滤未发布的headline' do
      headlines
      get v10_headlines_url,
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']['headlines'].size).to eq(4)
    end

    it '应按position正序' do
      headlines
      get v10_headlines_url,
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      first_headline = json['data']['headlines'].first
      expect(first_headline['source_type']).to eq('race')

      last_headline = json['data']['headlines'].last
      expect(last_headline['source_type']).to eq('race')
    end
  end
end