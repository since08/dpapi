# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.race do
    json.race_id          @ticket.race.id
    json.name             @ticket.race.name.to_s
    json.location         @ticket.race.location.to_s
    json.begin_date       @ticket.race.begin_date
    json.end_date         @ticket.race.end_date
    json.logo             @ticket.race.logo.to_s
    json.prize            @ticket.race.prize
    json.ticket_price     @ticket.race.ticket_price
    json.required_id_type @ticket.race.required_id_type
  end

  json.tickets do
    json.partial! 'ticket', ticket: @ticket
  end

  shipping_address = @current_user && @current_user.shipping_addresses.first
  json.partial! 'shipping_address', shipping_address: shipping_address if shipping_address
end
