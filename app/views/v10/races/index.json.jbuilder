# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.partial! 'v10/races/races', races: races, user: user
  end
  json.first_id races.first&.seq_id.to_i
  json.last_id  races.last&.seq_id.to_i
end
