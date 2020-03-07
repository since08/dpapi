# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.race_hosts do
    json.array! RaceHost.all.each do |host|
      json.id   host.id
      json.name host.name
    end
  end
end
