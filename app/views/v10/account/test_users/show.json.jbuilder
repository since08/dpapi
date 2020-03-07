# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

# data
json.data do
  json.is_test_user @current_user&.test_user.present?
end