# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result

# data
json.data do
  json.exist flag ? 1 : 0
end