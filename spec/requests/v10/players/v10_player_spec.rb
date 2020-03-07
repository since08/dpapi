require 'rails_helper'

RSpec.describe '/v10/players/:id', :type => :request do
  let(:player) { FactoryGirl.create(:player, name: 'poker_1') }
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:user) { FactoryGirl.create(:user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end

  context '没有该牌手' do
    it '应当返回 code: 1100006 (NOT_FOUND)' do
      get v10_player_url('not_exist'),
           headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100006)
    end
  end

  context '存在该牌手' do
    it '应当返回 code: 0' do
      get v10_player_url(player.player_id),
           headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['name']).to eq('poker_1')
      expect(json['data']['avatar']).to be_truthy
      expect(json['data']['ranking']).to be_truthy
      expect(json['data']['country']).to eq('中国')
      expect(json['data']['dpi_total_earning']).to eq('200')
      expect(json['data']['dpi_total_score']).to eq('404')
      expect(json['data']['memo']).to eq('测试')

      expect(get(json['data']['avatar'])).to eq(200)
    end

    it '已关注该牌手' do
      post v10_player_follow_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      get v10_player_url(player.player_id),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)
      json = JSON.parse(response.body)
      expect(json['data']['followed']).to eq(true)
    end
  end
end