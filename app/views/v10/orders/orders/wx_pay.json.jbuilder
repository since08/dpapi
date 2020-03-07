# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

json.data do
  json.appid order[:appid].to_s
  json.partnerid order[:partnerid].to_s
  json.package order[:package].to_s
  json.timestamp order[:timestamp].to_s
  json.prepayid order[:prepayid].to_s
  json.noncestr order[:noncestr].to_s
  json.sign order[:sign].to_s
end
