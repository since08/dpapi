# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.username   j_user.username
  json.password   j_user.password
  json.created_at j_user.created_at.to_i
end
