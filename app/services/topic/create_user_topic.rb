module Services
  module Topic
    class CreateUserTopic
      include Serviceable
      include Constants::Error::Account
      include Constants::Error::Common
      include Constants::Error::Topic

      def initialize(user, params)
        @user = user
        @params = params
      end

      def call
        long? ? create_long : create_short
      end

      def create_long
        user_topic = UserTopic.new(init_topic_params)
        user_topic.title = @params[:title].lstrip
        user_topic.cover_link = @params[:cover_link]
        return ApiResult.error_result(SYSTEM_ERROR) unless user_topic.save

        @user.increase_long_topics
        ApiResult.success_with_data(user_topic: user_topic)
      end

      def create_short
        return ApiResult.error_result(IMAGE_COUNT_OVER) if @params[:images].present? && @params[:images].count > 9

        user_topic = UserTopic.new(init_topic_params)
        return ApiResult.error_result(SYSTEM_ERROR) unless user_topic.save

        upload_images(@params[:images], user_topic)

        @user.increase_short_topics
        ApiResult.success_with_data(user_topic: user_topic)
      end

      def upload_images(images, topic)
        return if images.blank? || images.count.zero?
        images.each do |v|
          temp_image = TmpImage.find_by(id: v)
          next if temp_image.blank?
          UserTopicImage.create(user_topic_id: topic.id, remote_image_url: temp_image.image_path)
          temp_image.destroy!
        end
      end

      # 是否是长帖
      def long?
        @params[:body_type].eql?('long')
      end

      def init_topic_params
        {
          user_id: @user.id,
          body: @params[:body],
          body_type: @params[:body_type],
          lat: @params[:lat],
          lng: @params[:lng],
          address_title: @params[:address_title],
          address: @params[:address]
        }
      end
    end
  end
end
