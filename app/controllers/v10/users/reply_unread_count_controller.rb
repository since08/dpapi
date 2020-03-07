module V10
  module Users
    class ReplyUnreadCountController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index; end
    end
  end
end

