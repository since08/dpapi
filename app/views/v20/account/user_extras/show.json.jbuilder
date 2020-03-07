# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.user_extra do
    json.partial! 'v20/account/user_extras/base', user_extra: user_extra
  end
end