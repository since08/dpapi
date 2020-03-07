# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.headlines do
    json.array! @headlines do |headline|
      json.source_type  headline.source_type.downcase
      json.source_id    headline.source_id
      json.title        headline.source_title
    end
  end
end
