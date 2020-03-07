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