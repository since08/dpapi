# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.notifications do
    json.array! @notifications do |notification|
      json.id            notification.id
      json.notify_type   notification.notify_type
      json.title         notification.title
      json.content       notification.content
      json.color_type    notification.color_type
      json.read          notification.read
      json.created_at    notification.created_at.to_i

      if notification.notify_type == 'order'
        json.order_number notification.extra_data[:order_number]
        json.order_status notification.extra_data[:order_status]
        json.image        notification.extra_data[:image]
      end
    end
  end
end
