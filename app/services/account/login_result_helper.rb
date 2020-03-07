module Services
  module Account
    class LoginResultHelper
      include Serviceable

      attr_accessor :user, :access_token

      def initialize(user, access_token)
        self.user = user
        self.access_token = access_token
      end

      def call
        data = {
          user: user,
          access_token: access_token
        }
        ApiResult.success_with_data(data)
      end
    end
  end
end
