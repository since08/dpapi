# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! news do |list|
      json.partial! 'v10/news/base', list: list
    end
  end
  json.next_id next_id.to_s
end
