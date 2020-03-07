# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.banners do
    json.array! @banners do |banner|
      json.image        banner.image_url
      json.source_type  banner.source_type
      json.source_id    banner.source_id
      json.link         banner.link
    end
  end
end
