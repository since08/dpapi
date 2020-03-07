json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.followers do
    json.array! followers do |follower|
      user = follower.follower
      json.id user.user_uuid
      json.avatar user.avatar_url
      json.nick_name user.nick_name
      json.gender user.gender
      json.follower_count user.counter.follower_count
      json.following_count user.counter.following_count
      json.is_following follower.is_following
    end
  end
  json.follower_count followers.size
end
