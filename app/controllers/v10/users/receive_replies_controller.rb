module V10
  module Users
    class ReceiveRepliesController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        @dynamics = Reply.user_replies(@current_user)
                         .page(params[:page])
                         .per(params[:page_size])
        Reply.all.read!(@current_user)
      end
    end
  end
end

