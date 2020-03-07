# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.array! @crowdfundings do |cf|
    json.partial! 'crowdfunding', crowdfunding: cf
    json.race do
      json.partial! 'race_info', race: cf.race
    end
  end
end
