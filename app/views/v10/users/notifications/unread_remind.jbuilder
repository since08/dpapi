# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.unread_count @unread_count
  unless @recent_notification.nil?
    json.recent_notification do
      json.id            @recent_notification.id
      json.notify_type   @recent_notification.notify_type
      json.title         @recent_notification.title
      json.content       @recent_notification.content
      json.color_type    @recent_notification.color_type
      json.read          @recent_notification.read
      json.created_at    @recent_notification.created_at.to_i

      if @recent_notification.notify_type == 'order'
        json.order_number @recent_notification.extra_data[:order_number]
        json.order_status @recent_notification.extra_data[:order_status]
        json.image        @recent_notification.extra_data[:image]
      end
    end
  end
end
