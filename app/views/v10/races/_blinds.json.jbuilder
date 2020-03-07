json.array! blinds do |blind|
  json.blind_id blind.id
  json.blind_type  blind.blind_type
  json.level       blind.level
  json.small_blind blind.small_blind
  json.big_blind   blind.big_blind
  json.ante        blind.ante
  json.race_time   blind.race_time
  json.content     blind.content
end