module V10
  module Users
    class DynamicsController < ApplicationController
      before_action :current_user
      def index
        return render_api_error(Constants::Error::Http::HTTP_LOGIN_REQUIRED) if @current_user.blank?
        @dynamics = @current_user.dynamics
                                 .normal_dynamics
                                 .order(created_at: :desc)
                                 .page(params[:page])
                                 .per(params[:page_size])
      end

      private

      def current_user
        # user_uuid = CurrentRequestCredential.current_user_id
        # return nil if user_uuid.nil?
        @current_user = User.by_uuid(params[:user_id])
      end
    end
  end
end

