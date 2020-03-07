module V10
  module Account
    class TestUsersController < ApplicationController
      include UserAccessible
      before_action :current_user

      def show; end
    end
  end
end
