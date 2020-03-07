# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.id comment.id
  json.topic_type comment.topic_type
  json.topic_id comment.topic_id
  json.body comment.body
  json.created_at comment.created_at.to_i
  json.partial! 'v10/topic/user_info', user: comment.user
  json.typological 'comment'
end
