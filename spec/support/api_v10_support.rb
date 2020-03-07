module APIV10Support
  extend ActiveSupport::Concern

  included do
    let(:http_headers) do
      {
        ACCEPT: 'application/json',
        HTTP_ACCEPT: 'application/json',
        HTTP_X_DP_LANG: 'zh',
        HTTP_X_DP_CLIENT_IP: 'localhost',
        HTTP_X_DP_APP_KEY: '467109f4b44be6398c17f6c058dfa7ee'
      }
    end
  end
end
