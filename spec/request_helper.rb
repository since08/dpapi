module RequestHelper
  extend ActiveSupport::Concern
  included do
    def request_header
      http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)
    end

    let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
    let(:http_headers) do
      {
        ACCEPT: 'application/json',
        HTTP_ACCEPT: 'application/json',
        HTTP_X_DP_LANG: 'zh',
        HTTP_X_DP_CLIENT_IP: 'localhost',
        HTTP_X_DP_APP_KEY: '467109f4b44be6398c17f6c058dfa7ee',
      }
    end
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user_extra) { FactoryGirl.create(:user_extra, user: user, status: 'passed') }
    let(:access_token) do
      AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
    end
  end
end
