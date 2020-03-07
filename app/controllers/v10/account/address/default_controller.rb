module V10
  module Account
    module Address
      class DefaultController < ApplicationController
        include UserAccessible
        before_action :login_required, :user_self_required

        def create
          address = ShippingAddress.find(params[:address_id])
          address.update!(default: true)
          @current_user.shipping_addresses.where.not(id: params[:address_id]).update(default: false)
          render_api_success
        end
      end
    end
  end
end
