module V10
  module Users
    class ProfilesController < ApplicationController
      def show
        user = User.by_uuid(params[:user_id])
        render 'show', locals: { user: user }
      end
    end
  end
end
