# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.id                @player.player_id.to_s
  json.ranking           @player.ranking
  json.name              @player.name.to_s
  json.avatar            @player.avatar_thumb.to_s
  json.country           @player.country.to_s
  json.dpi_total_earning @player.dpi_total_earning.to_s
  json.dpi_total_score   @player.dpi_total_score.to_s
  json.memo              @player.memo.to_s
  json.followed          PlayerFollow.followed?(@user&.id, @player.id)
end
