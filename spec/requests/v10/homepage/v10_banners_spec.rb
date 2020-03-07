require 'rails_helper'

RSpec.describe '/v10/banners', :type => :request do
  let(:banners) do
    FactoryGirl.create(:banner, published: false)
    FactoryGirl.create(:banner, published: true, position: 5)
    FactoryGirl.create(:banner, source_type: 'race', source_id: 1, published: true, position: 1)
    FactoryGirl.create(:banner, source_type: 'info', source_id: 1, published: true, position: 2)
    FactoryGirl.create(:banner, source_type: 'video', source_id: 1, published: true, position: 2)
  end
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }


  context '获取banner列表' do
    it '应过滤未发布的banner' do
      banners
      get v10_banners_url,
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']['banners'].size).to eq(4)
    end

    it '应按position正序' do
      banners
      get v10_banners_url,
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      first_banner = json['data']['banners'].first
      expect(first_banner['source_type']).to eq('race')

      last_banner = json['data']['banners'].last
      expect(last_banner['source_type']).to eq('link')
    end
  end
end