module V10
  module Account
    class AddressController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        @addresses = @current_user.shipping_addresses.order(default: :desc).order(created_at: :desc)
      end

      def create
        address_add_service = Services::Account::AddressAddService
        api_result = address_add_service.call(@current_user, permit_params)
        render_api_result api_result
      end

      private

      def permit_params
        params.permit(:id,
                      :consignee,
                      :mobile,
                      :address,
                      :address_detail,
                      :post_code,
                      :default,
                      :province,
                      :city,
                      :area)
      end

      def render_api_result(api_result)
        return render_api_error(api_result.code, api_result.msg) if api_result.failure?
        render_api_success
      end
    end
  end
end

