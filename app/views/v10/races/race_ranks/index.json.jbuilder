# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    race_ranks = @race.race_ranks.includes(:player)
    json.array! race_ranks do |rank|
      json.rank_id         rank.id
      json.ranking         rank.ranking
      json.earning         number_with_delimiter rank.earning
      json.score           rank.score
      json.player do
        json.player_id  rank.player.player_id
        json.name       rank.player.name
      end
    end
  end
end
