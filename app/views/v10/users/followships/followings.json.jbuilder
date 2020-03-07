json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.followings do
    json.array! followings do |following|
      user = following.following
      json.id user.user_uuid
      json.avatar user.avatar_url
      json.nick_name user.nick_name
      json.gender user.gender
      json.follower_count user.counter.follower_count
      json.following_count user.counter.following_count
    end
  end
  json.following_count followings.size
end
