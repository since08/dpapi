# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
# rubocop:disable Metrics/BlockLength
json.data do
  json.race do
    json.race_id         @race.id
    json.name            @race.name.to_s
    json.seq_id          @race.seq_id
    json.logo            @race.preview_logo
    json.big_logo        @race.big_logo
    json.prize           @race.prize
    json.blind           @race.blind
    json.location        @race.location.to_s
    json.participants    @race.participants.to_s
    json.begin_date      @race.begin_date
    json.end_date        @race.end_date
    json.status          @race.status
    json.ticket_price    @race.ticket_price
    json.describable     @race.describable
    json.description     @race.race_desc.try(:description).to_s
    json.followed        RaceFollow.followed?(@user&.id, @race.id)
    json.ticket_status   @race.ticket_status
    json.ticket_sellable @race.ticket_sellable
  end

  if @race.parent
    json.parent_race do
      json.race_id  @race.parent.id
      json.name     @race.parent.name
      json.logo     @race.parent.preview_logo
    end
  end

  json.ranks do
    json.partial! 'v10/races/ranks', ranks: @race.race_ranks
  end

  json.schedules do
    json.partial! 'v10/races/schedules', race_schedules: @race.race_schedules.default_order
  end

  json.blinds do
    json.partial! 'v10/races/blinds', blinds: @race.race_blinds.position_asc
  end

  json.schedule_memo @race.race_extra&.schedule_memo
  json.blind_memo @race.race_extra&.blind_memo
end
