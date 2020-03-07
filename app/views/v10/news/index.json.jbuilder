# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! types do |type|
      json.id          type.id
      json.name        type.name.to_s
    end
  end
end
