# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.array! @reports do |report|
    json.crowdfunding_id report.crowdfunding_id
    json.crowdfunding_player_id report.crowdfunding_player_id
    json.crowdfunding_player_name report.crowdfunding_player&.player&.name
    json.record_time report.record_time.to_i
    json.name report.name
    json.title report.title
    json.level report.level
    json.small_blind report.small_blind
    json.big_blind report.big_blind
    json.ante report.ante
    json.description report.description
    json.created_at report.created_at.to_i
  end
end
