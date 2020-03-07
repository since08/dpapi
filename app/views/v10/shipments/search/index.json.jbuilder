# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.success shipments['Success']
  json.state shipments['State']
  json.express_code shipments['ShipperCode']
  json.shipping_number shipments['LogisticCode']
  json.order_number shipments['OrderCode'].to_s
  json.traces do
    json.array! shipments['Traces'] do |item|
      json.accept_station item['AcceptStation']
      json.accept_time item['AcceptTime']
    end
  end
  json.reason shipments['Reason'].to_s
  json.site express[:site]
  json.phone express[:phone]
end
