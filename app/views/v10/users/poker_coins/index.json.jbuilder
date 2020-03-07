# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.total_poker_coins @current_user.counter.total_poker_coins
  json.detail do
    json.array! @poker_coins do |item|
      json.memo item.memo.to_s
      json.number item.number
      json.created_at item.created_at.to_i
    end
  end
end
