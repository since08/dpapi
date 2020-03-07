# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  @releases.each do |release|
    json.set! :"#{release.keywords}", release.published
  end
end
