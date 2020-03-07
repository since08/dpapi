require 'rails_helper'

RSpec.describe '/v10/players/:id/ranks', :type => :request do
  let!(:player) do
    FactoryGirl.create(:player, name: 'poker_1')
  end
  let(:race) { FactoryGirl.create(:race) }
  let(:race_ranks) do
    FactoryGirl.create(:race_rank ,race: race, player: player)
  end
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }


  context '获取牌手的战绩列表' do
    it '返回空列表' do
      get v10_player_ranks_url(player.player_id),
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']).to eq([])
    end

    it '获取列表' do
      race_ranks
      get v10_player_ranks_url(player.player_id),
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      ranks = json['data']
      expect(ranks.size).to eq(1)
    end
  end
end