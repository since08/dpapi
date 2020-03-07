json.parent_comment do
  json.parent_comment_id reply.comment.id
  json.parent_comment_body reply.comment.body
  json.parent_comment_user_id reply.comment.user.user_uuid
  json.parent_comment_user reply.comment.user.nick_name
  json.parent_comment_user_avatar reply.comment.user.avatar_path.to_s
  json.parent_comment_user_signature reply.comment.user.signature.to_s
  json.parent_comment_user_official reply.comment.user.official?
end
if reply.reply
  json.parent_reply do
    json.parent_reply_id reply.reply.id
    json.parent_reply_body reply.reply.body
    json.parent_reply_user_id reply.reply.user.user_uuid
    json.parent_reply_user reply.reply.user.nick_name
    json.parent_reply_user_avatar reply.reply.user.avatar_path.to_s
    json.parent_reply_user_signature reply.reply.user.signature.to_s
    json.parent_reply_user_official reply.reply.user.official?
  end
end