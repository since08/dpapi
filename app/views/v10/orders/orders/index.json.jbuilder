# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @orders do |order|
      json.order_info do
        json.partial! 'order_info', order_info: order
      end
      json.race_info do
        json.partial! 'race_snapshot', race_info: order.snapshot
      end
      json.ticket do
        json.partial! 'ticket', ticket: order.ticket
      end
    end
  end
  json.next_id @orders.last&.order_number.to_s
end

