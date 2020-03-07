# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.race_info do
    json.race_id @crowdfunding.race.id
    json.race_name @crowdfunding.race.name.to_s
    json.cf_cond @crowdfunding.cf_cond
    json.prize @crowdfunding.race.prize
    json.begin_date @crowdfunding.race.begin_date
    json.end_date @crowdfunding.race.end_date
  end
  json.players do
    json.array! @players do |cf_player|
      json.partial! 'short_info', cf_player: cf_player
    end
  end
end
