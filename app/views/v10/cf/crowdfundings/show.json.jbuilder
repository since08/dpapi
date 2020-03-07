# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.partial! 'crowdfunding', crowdfunding: @crowdfunding
  json.categories do
    json.array! @crowdfunding.crowdfunding_categories do |category|
      json.name category.name
      json.description category.description
    end
  end
  json.race do
    json.partial! 'race_info', race: @crowdfunding.race
  end
end
