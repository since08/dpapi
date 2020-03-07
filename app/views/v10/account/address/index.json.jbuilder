# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

# data
json.data do
  json.items do
    json.array! @addresses do |ads|
      json.id ads.id
      json.consignee ads.consignee.to_s
      json.mobile ads.mobile.to_s
      json.address ads.address.to_s
      json.address_detail ads.address_detail.to_s
      json.default ads.default
      json.province ads.province
      json.city ads.city
      json.area ads.area
    end
  end
end