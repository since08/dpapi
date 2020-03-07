# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.notifications do
    json.array! @notifications do |notification|
      next if notification.source.blank?
      json.id            notification.id
      json.notify_type   notification.notify_type
      json.read          notification.read
      json.created_at    notification.created_at.to_i

      json.from_user do
        json.partial! 'v10/users/user_info', user: notification.from_user
      end

      json.to_user do
        json.partial! 'v10/users/user_info', user: notification.user
      end

      json.content do
        json.topic_id notification.source.topic_id
        json.topic_type notification.source.topic_type
        unless notification.notify_type.eql?('topic_like')
          json.comment notification.source.body.to_s
        end
      end
    end
  end
end
