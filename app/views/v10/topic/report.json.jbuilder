# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.user_id          @report.user.user_uuid
  json.user_topic_id    @report.user_topic_id
  json.body             @report.body.to_s
  json.report_type      @report.report_type.to_s
  json.created_at       @report.created_at.to_i
end
