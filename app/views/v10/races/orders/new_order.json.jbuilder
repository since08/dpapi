# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.race do
    json.race_id      @race.id
    json.name         @race.name.to_s
    json.location     @race.location.to_s
    json.begin_date   @race.begin_date
    json.end_date     @race.end_date
    json.logo         @race.logo.to_s
    json.prize        @race.prize
    json.ticket_price @race.ticket_price
  end

  json.ticket_info do
    json.partial! 'ticket_info', ticket_info: @race.ticket_info
  end

  json.shipping_address do
    shipping_address = @user.shipping_addresses.first
    json.partial! 'shipping_address', shipping_address: shipping_address if shipping_address
  end

  json.ordered PurchaseOrder.purchased?(@user.id, @race.id)
end
