# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @dynamics do |list|
      json.mine do
        if list.reply.present?
          json.id list.reply.id
          json.comment list.reply.body
          json.created_at list.reply.created_at.to_i
        else
          json.id list.comment.id
          json.comment list.comment.body
          json.created_at list.comment.created_at.to_i
        end
        json.partial! 'v10/topic/user_info', user: list.reply_user
      end
      json.other do
        json.id list.id
        json.comment list.body
        json.created_at list.created_at.to_i
        json.partial! 'v10/topic/user_info', user: list.user
      end
    end
  end
end
