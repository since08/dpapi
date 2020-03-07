# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.array! @templates do |item|
    json.id item.id
    json.name item.name
  end
end
