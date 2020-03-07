# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! videos do |video|
      json.partial! 'v10/videos/new_base', video: video
    end
  end
  json.next_id next_id.to_s
end
