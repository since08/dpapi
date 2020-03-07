# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.type type
  json.info do
    if type.eql?('login')
      json.access_token data[:access_token]
      json.partial! 'v10/account/users/user_base', user: data[:user]
    else
      json.access_token data[:access_token]
    end
  end
end