module Services
  module Account
    class AddressAddService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :user, :user_params

      def initialize(user, user_params)
        self.user = user
        self.user_params = user_params
      end

      def call
        # 检查参数是否为空
        if user_params[:consignee].blank? || user_params[:mobile].blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        # 判断手机格式是否正确
        return ApiResult.error_result(MOBILE_FORMAT_WRONG) unless UserValidator.mobile_valid?(user_params[:mobile])

        user_params[:id].blank? ? create_address : update_address
      end

      private

      def create_address
        address = user.shipping_addresses.create! user_params
        update_other_default_false(address.id, address.default)
        ApiResult.success_result
      end

      def update_address
        address_id = user_params.delete(:id)
        address = ShippingAddress.find(address_id)
        address.update! user_params
        update_other_default_false(address_id, user_params[:default])
        ApiResult.success_result
      end

      def update_other_default_false(address_id, send_default)
        send_default.present? &&
          user.shipping_addresses.where.not(id: address_id).update(default: false)
      end
    end
  end
end
