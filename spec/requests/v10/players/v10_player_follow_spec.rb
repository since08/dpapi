require 'rails_helper'

RSpec.describe '/v10/players/:id/follow', :type => :request do
  let(:player) do
    FactoryGirl.create(:player, name: 'poker_1')
  end
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let!(:user) { FactoryGirl.create(:user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end


  context '关注牌手' do
    it '关注成功' do
      expect(player.follows_count).to eq(0)
      post v10_player_follow_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(player.reload.follows_count).to eq(1)
    end

    it '重复关注，只创建一个记录' do
      post v10_player_follow_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      post v10_player_follow_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      follows = PlayerFollow.where(player_id: player.id, user_id: user.id)
      expect(follows.size).to eq(1)
      expect(player.reload.follows_count).to eq(1)
    end
  end

  context '取消关注牌手' do
    it '不存在关注关系，应返回 找不到指定记录' do
      delete v10_player_follow_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100006)
    end

    it '取消关注成功' do
      post v10_player_follow_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(player.reload.follows_count).to eq(1)

      delete v10_player_follow_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(player.reload.follows_count).to eq(0)
    end
  end
end