# meta info
json.partial! 'common/meta'
# code & msg
json.result do
  json.code @result['code']
  json.msg @result['msg']
  json.data @result['body'].to_s
end