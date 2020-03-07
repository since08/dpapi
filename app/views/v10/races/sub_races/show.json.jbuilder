# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.race_id         @sub_race.id
  json.name            @sub_race.name.to_s
  json.prize           @sub_race.prize
  json.ticket_price    @sub_race.ticket_price
  json.blind           @sub_race.blind
  json.location        @sub_race.location.to_s
  json.begin_date      @sub_race.begin_date
  json.end_date        @sub_race.end_date
  json.days            @sub_race.days
  json.participants    @sub_race.participants
  json.roy             @sub_race.roy
  json.begin_time      @sub_race.schedule_begin_time.to_s
  json.schedules_markdown @sub_race.race_desc.schedules.to_s if @sub_race.race_desc

  json.schedules do
    json.partial! 'v10/races/schedules', race_schedules: @sub_race.race_schedules.default_order
  end

  json.ranks do
    json.partial! 'v10/races/ranks', ranks: @sub_race.race_ranks
  end

  json.blinds do
    blinds = @sub_race.race_blinds.position_asc
    json.partial! 'v10/races/blinds', blinds: blinds
  end
end
