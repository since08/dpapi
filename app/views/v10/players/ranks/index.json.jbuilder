# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.array! @ranks.includes(:race) do |rank|
    race = rank.race
    next if race.nil?

    json.rank do
      json.ranking rank.ranking
      json.earning rank.earning
      json.score   rank.score
    end

    json.race do
      json.race_id           race.id
      json.name              race.name
      json.ticket_price      race.ticket_price
      json.location          race.location
      json.begin_date        race.begin_date
      json.end_date          race.end_date
      json.participants      race.participants.to_s
    end

    if race.parent
      json.parent_race do
        json.race_id  race.parent.id
        json.name     race.parent.name
      end
    end
  end
end
