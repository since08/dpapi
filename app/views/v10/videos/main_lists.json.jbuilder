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
  unless top_video.nil?
    json.topped do
      json.partial! 'v10/videos/top_video', video: top_video
    end
  end
  json.next_id next_id.to_s
end