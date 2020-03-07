module Services
  module Topic
    class CreateLikes
      include Serviceable
      include Constants::Error::Account

      def initialize(resource, user)
        @resource = resource
        @user = user
      end

      def call
        return ApiResult.error_result(USER_BLOCKED) if @user.blocked?
        # 查看该话题用户是否点过赞
        topic = @user.topic_likes.find_by(topic: @resource)
        if topic.blank?
          @user.topic_likes.create(topic: @resource)
          @resource.increase_likes
        else
          topic.destroy!
          @resource.decrease_likes
        end
        ApiResult.success_result
      end
    end
  end
end
