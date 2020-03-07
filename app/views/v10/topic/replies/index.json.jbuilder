# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @replies do |reply|
      json.partial! 'reply_info', reply: reply
      json.partial! 'v10/topic/user_info', user: reply.user
      json.typological 'reply'
    end
  end
  json.total_count @replies.count
end
