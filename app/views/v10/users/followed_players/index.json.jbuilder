# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.followed_players do
    json.array! @followed_players.includes(:player) do |followed_player|
      player = followed_player.player
      json.id                player.player_id
      json.name              player.name.to_s
      json.avatar            player.avatar_thumb.to_s
      json.country           player.country.to_s
      json.dpi_total_earning player.dpi_total_earning.to_s
      json.dpi_total_score   player.dpi_total_score.to_s
    end
  end
  json.next_id @followed_players.last&.id.to_s
end
