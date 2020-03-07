module V10
  module Users
    class JmessageController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required, only: [:create, :delete]

      def index
        user = User.by_uuid(params[:user_id])
        return render_api_error(Constants::Error::Sign::USER_NOT_FOUND) if user.blank?
        result = Services::Jmessage::CreateUser.call(user)
        return render_api_error(result.code, result.msg) if result.failure?
        render :index, locals: { j_user: result.data[:j_user] }
      end

      def create
        jmessage_service = Services::Jmessage::CreateUser
        result = jmessage_service.call(@current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        render :create, locals: { j_user: result.data[:j_user] }
      end

      def delete
        user = @current_user.j_user
        return render_api_error(Constants::Error::Sign::USER_NOT_FOUND) if user.blank?
        user.delete_user
        render_api_success
      end
    end
  end
end

