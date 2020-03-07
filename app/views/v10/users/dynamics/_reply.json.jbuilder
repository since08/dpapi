json.my_name item.user.nick_name
json.my_reply_body item.body
json.partial! 'v10/topic/replies/parent', reply: item
