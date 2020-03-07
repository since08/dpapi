module V10
  module Account
    module Address
      class DeleteController < ApplicationController
        include UserAccessible
        before_action :login_required, :user_self_required

        def create
          address = ShippingAddress.find(params[:address_id])
          address.destroy!
          render_api_success
        end
      end
    end
  end
end

