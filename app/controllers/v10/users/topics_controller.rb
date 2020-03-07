module V10
  module Users
    class TopicsController < ApplicationController
      include CheckTopicLike
      before_action :set_user_like_ids

      def index
        @topics = UserTopic.sorted.page(params[:page]).per(params[:page_size]).includes(:topic_images, :counter)
      end

      def recommends
        @topics = UserTopic.recommended.sorted.page(params[:page]).per(params[:page_size]).includes(:topic_images, :counter)
      end

      def details
        @topic = UserTopic.find(params[:id])
        @topic.increase_page_views
      end
    end
  end
end

