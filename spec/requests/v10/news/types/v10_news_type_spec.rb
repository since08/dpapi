require 'rails_helper'

RSpec.describe 'v10_news_type', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  # 初始化10条资讯
  let(:init_news) do
    10.times { FactoryGirl.create(:info) }
  end

  describe '不存在资讯类别' do
    it "should return code 1100006" do
      get v10_news_type_url('no_exists'),
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100006)
    end
  end

  describe '存在资讯类别 且该资讯和资讯类别均有发布' do
    it "should return code 0" do
      init_news
      get v10_news_type_url(InfoType.first.id),
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['items'].size).to eq(1)
      expect(json['data']['items'][0]['type']).to be_truthy
      expect(json['data']['items'][0]['title']).to be_truthy
      expect(json['data']['items'][0]['date']).to be_truthy
      expect(json['data']['items'][0]['source_type']).to be_truthy
      expect(json['data']['items'][0]['source']).to be_truthy
      expect(json['data']['items'][0]['description']).to be_truthy

      expect(get(json['data']['items'][0]['image'])).to eq(200)

      expect(get(json['data']['items'][0]['image_thumb'])).to eq(200)
    end
  end
end