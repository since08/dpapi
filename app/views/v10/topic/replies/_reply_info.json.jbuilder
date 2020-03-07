json.id reply.id
json.body reply.body
json.created_at reply.created_at.to_i
json.partial! 'parent', reply: reply