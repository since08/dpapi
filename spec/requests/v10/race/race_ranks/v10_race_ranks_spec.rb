require 'rails_helper'

RSpec.describe '/v10/races/race_id/sub_races', type: :request do

  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let(:user) { FactoryGirl.create(:user) }
  let(:race) { FactoryGirl.create(:race) }
  let(:race_ranks) do
    10.times { FactoryGirl.create(:race_rank ,race: race) }
  end

  context '访问赛事排行' do
    it '默认按名次排序' do
      race_ranks
      get v10_race_race_ranks_url(race.id), headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      ranks = json['data']['items']
      expect(ranks.size).to       eq(10)
      ranks.each_with_index do |rank, index|
        next if index == 0

        expect(ranks[index - 1]['ranking']).to   eq(rank['ranking'] - 1)
      end
    end

    it '返回排行榜' do
      race_ranks
      get v10_race_race_ranks_url(race.id), headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      ranks = json['data']['items']
      expect(ranks.class).to      eq(Array)
      expect(ranks.size).to       eq(10)
      ranks.each do |rank|
        expect(rank['rank_id'].class).to   eq(Fixnum)
        expect(rank['ranking'].class).to     eq(Fixnum)
        expect(rank['score'].class).to     eq(Fixnum)
        expect(rank['earning'].class).to   eq(String)
        player = rank['player']
        expect(player['player_id'].class).to eq(String)
        expect(player['name'].class).to        eq(String)
      end
    end
  end
end