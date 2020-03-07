module V10
  module Orders
    class CompleteController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required
      before_action :set_order

      def create
        @order.completed! if @order.delivered?
        render_api_success
      end

      private

      def set_order
        @order = @current_user.orders.find_by!(order_number: params[:order_id])
      end
    end
  end
end
