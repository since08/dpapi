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
    json.logo         @race.preview_logo
    json.ticket_sellable @race.ticket_sellable
  end

  prices = @tickets.pluck(:price)
  json.max_price number_with_delimiter prices.max
  json.min_price number_with_delimiter prices.min
  json.tickets do
    json.array! @tickets do |ticket|
      json.partial! 'ticket', ticket: ticket
    end
  end
end