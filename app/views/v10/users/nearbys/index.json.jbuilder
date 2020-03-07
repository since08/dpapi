# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.nearby_users do
    json.array! @nearby_users do |user|
      json.user_id    user.user_uuid
      json.nick_name  user.nick_name
      json.gender     user.gender
      json.avatar     user.avatar_url.to_s
      json.signature  user.signature.to_s
      json.distance   user.distance
    end
  end
end
