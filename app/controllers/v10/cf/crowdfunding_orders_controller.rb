module V10
  module Cf
    class CrowdfundingOrdersController < ApplicationController
      include UserAccessible
      include Constants::Error::Common
      include Constants::Error::Order
      before_action :login_required
      before_action :set_order, only: [:wx_paid_result, :show, :destroy]

      def index
        orders = @current_user.crowdfunding_orders.paid_status
        if CrowdfundingOrder.record_statuses.keys.include?(params[:status])
          orders = orders.where(record_status: params[:status])
        end
        @orders = orders.page(params[:page]).per(params[:page_size])
        render :index
      end

      def create
        return render_api_error(MISSING_PARAMETER) if params[:number].to_i <= 0
        cf_player = CrowdfundingPlayer.published.find(params[:cf_player_id])
        user_extra = @current_user.user_extras.find(params[:user_extra_id])
        result = Services::CrowdfundingOrders::CreateService.call(@current_user, user_extra, cf_player, params)
        return render_api_error(result.code, result.msg) if result.failure?
        render :create, locals: { order: result.data[:order] }
      end

      def show; end

      def destroy
        @order.deleted!
        render_api_success
      end

      def wx_paid_result
        result = WxPay::Service.order_query(out_trade_no: @order.order_number)
        unless result['trade_state'] == 'SUCCESS'
          return render_api_error(INVALID_ORDER, result['trade_state_desc'] || result['err_code_des'])
        end
        api_result = Services::Notify::WxCfNotifyNotifyService.call(result[:raw]['xml'])

        return render_api_error(INVALID_ORDER, api_result.msg) if api_result.failure?

        render_api_success
      end

      def set_order
        @order = CrowdfundingOrder.find_by!(order_number: params[:id])
      end
    end
  end
end

