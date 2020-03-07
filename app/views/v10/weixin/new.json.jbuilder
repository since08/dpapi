# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.appId          @sign_package['appId']
  json.nonceStr       @sign_package['nonceStr']
  json.timestamp      @sign_package['timestamp']
  json.url            @sign_package['url']
  json.signature      @sign_package['signature']
  json.rawString      @sign_package['rawString']
end