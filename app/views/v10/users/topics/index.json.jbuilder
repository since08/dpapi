# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @topics do |topic|
      json.partial! 'v10/users/user_topics/topic', topic: topic
    end
  end
end
