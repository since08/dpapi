# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.id              @topic_image.id
  json.user_topic_id   @topic_image.user_topic_id
  json.image_path      @topic_image.image_path.to_s
end
