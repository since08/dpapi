json.array! ranks.includes(:player) do |rank|
  json.rank_id         rank.id
  json.ranking         rank.ranking
  json.earning         number_with_delimiter rank.earning
  json.score           rank.score
  json.player do
    json.player_id  rank.player.player_id
    json.name       rank.player.name
  end
end