# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! user_extras do |user_extra|
      json.partial! 'v20/account/user_extras/user_extra_item', user_extra: user_extra
    end
  end
end