# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.activity do
    json.id            @activity.id
    json.title         @activity.title
    json.tag           @activity.tag
    json.link          @activity.link
    json.banner        @activity.banner_url
    json.pushed_img    @activity.pushed_img_url
    json.description   @activity.description
    json.activity_time @activity.activity_time.to_i
    json.updated_time  @activity.updated_at.to_i
    json.push_type     @activity.push_type
  end
end
