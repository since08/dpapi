# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @comments do |comment|
      json.id comment.id
      json.body comment.body
      json.recommended comment.recommended
      json.created_at comment.created_at.to_i
      json.partial! 'v10/topic/user_info', user: comment.user
      json.typological 'comment'
      json.total_count comment.replies.count
    end
  end
  json.total_count @video.total_comments
end
