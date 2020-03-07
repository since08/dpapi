# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.user_id user.user_uuid
  json.nick_name user.nick_name.to_s
  json.gender user.gender
  json.avatar user.avatar_path.to_s
  json.signature user.signature.to_s
  json.official user.role.eql?('official')
  json.following_count user.counter.following_count
  json.follower_count user.counter.follower_count
end
