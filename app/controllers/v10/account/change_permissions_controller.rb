module V10
  module Account
    class ChangePermissionsController < ApplicationController
      ACCOUNT_TYPES = %w(mobile email).freeze
      include UserAccessible
      include Constants::Error::Sign
      include Constants::Error::Account
      before_action :login_required, :user_self_required

      def create
        account_type = params[:type]
        return render_api_error(UNSUPPORTED_TYPE) unless ACCOUNT_TYPES.include?(account_type)

        change_times(account_type)
      end

      private

      def change_times(account_type)
        start_time = Time.current - 30.days
        change_item = @current_user.account_change_stats.where(account_type: account_type)
                                   .where('change_time > ?', start_time)
                                   .count
        # 如果change_item的值大于0， 说明今天之前的30天有修改过
        return render_api_error(NO_CHANGE_PERMISSION) if change_item.positive?
        render_api_success
      end
    end
  end
end
