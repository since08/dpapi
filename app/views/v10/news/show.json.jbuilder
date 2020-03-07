# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! news do |list|
      json.partial! 'v10/news/show_base', list: list
    end
  end
  unless top_new.nil?
    json.topped do
      json.partial! 'v10/news/base', list: top_new
    end
  end
  json.next_id next_id.to_s
end
