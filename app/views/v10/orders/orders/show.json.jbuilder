# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.order_info do
    json.partial! 'order_info', order_info: @order
  end
  json.race_info do
    json.partial! 'race_snapshot', race_info: @order.snapshot
  end
  json.ticket do
    json.partial! 'ticket', ticket: @order.ticket
  end
  json.user_extra do
    json.partial! 'user_extra', user_extra: @order.user_extra
  end
end

