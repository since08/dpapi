module V10
  module News
    class InfosController < ApplicationController
      before_action :current_user

      def show
        @info = Info.find(params[:id])
        @info.increase_page_views
      end

      private

      def current_user
        user_uuid = CurrentRequestCredential.current_user_id
        @current_user = user_uuid.nil? ? nil : User.by_uuid(user_uuid)
      end
    end
  end
end

