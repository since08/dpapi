module CheckTopicLike
  extend ActiveSupport::Concern

  def set_user_like_ids
    @user_like_ids ||=
      current_user ? TopicLike.where(user_id: current_user.id, topic_type: 'UserTopic', canceled: false).pluck(:topic_id) : []
  end

  private

  def current_user
    user_uuid = CurrentRequestCredential.current_user_id
    return nil if user_uuid.nil?
    @current_user ||= User.by_uuid(user_uuid)
  end
end
