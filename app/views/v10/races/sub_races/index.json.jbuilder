# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @sub_races do |race|
      json.race_id         race.id
      json.name            race.name.to_s
      json.prize           race.prize
      json.ticket_price    race.ticket_price
      json.blind           race.blind
      json.location        race.location.to_s
      json.begin_date      race.begin_date
      json.end_date        race.end_date
      json.begin_time      race.schedule_begin_time.to_s
      json.days            race.days
      json.roy             race.roy
    end
  end
end
