# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @topics do |topic|
      json.partial! 'topic', topic: topic
    end
  end
end
