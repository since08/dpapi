# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! race do |item|
      json.date item[1][:date].to_s
      json.counts item[1][:counts].to_i
      json.follows item[1][:follows].to_i
      json.orders item[1][:orders].to_i
    end
  end
end
