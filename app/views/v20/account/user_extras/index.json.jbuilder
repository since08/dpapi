# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.chinese_ids do
      json.array! chinese_ids do |user_extra|
        json.partial! 'v20/account/user_extras/base', user_extra: user_extra
      end
    end
    json.passport_ids do
      json.array! passport_ids do |user_extra|
        json.partial! 'v20/account/user_extras/base', user_extra: user_extra
      end
    end
  end
end