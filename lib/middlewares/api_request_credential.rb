module DpAPI
  # rubocop:disable Metrics/CyclomaticComplexity: 7
  # rubocop:disable Metrics/LineLength: 130
  class ApiRequestCredential
    attr_accessor :client_ip, :app_key, :access_token, :user_agent
    SKIP_PATH_REGEX = %r{^/*factory|pay/}
    def initialize(app)
      @app = app
    end

    def call(env)
      # 解析请求头信息 并初始化到线程中
      self.client_ip     = env['HTTP_X_DP_CLIENT_IP'].eql?('localhost') ? '127.0.0.1' : env['HTTP_X_DP_CLIENT_IP']
      self.app_key       = env['HTTP_X_DP_APP_KEY']
      self.access_token  = env['HTTP_X_DP_ACCESS_TOKEN']
      self.user_agent    = env['HTTP_USER_AGENT']
      Rails.logger.info "[ApiRequest] client_ip: #{client_ip}, app_key: #{app_key}, access_token: #{access_token}, user_agent: #{user_agent}"
      if env['REQUEST_URI'].match SKIP_PATH_REGEX
        @app.call(env)
      else
        verify_request(env)
      end
    end

    private

    # rubocop:disable Metrics/PerceivedComplexity
    def verify_request(env)
      # 检查请求头是否包含 client_ip 和 app_key
      return http_no_credential if client_ip.blank? || app_key.blank?

      # 检查app_key是否正确
      affiliate_app = AffiliateApp.by_app_key(app_key)
      return http_invalid_credential if affiliate_app.nil?

      # 如果用户有传access_token 那么拿着access_token去缓存获取对应的信息
      current_user_id  = nil
      app_access_token = nil
      if access_token.present?
        app_access_token = AppAccessToken.jwt_decode(affiliate_app.try(:app_secret), access_token)
        current_user_id  = app_access_token[0]['user_id'] if app_access_token.present?
      end

      if access_token.present? && app_access_token.nil?
        return http_token_expired
      end

      # 初始化信息到线程中
      CurrentRequestCredential.initialize(client_ip, app_key, access_token, current_user_id, app_access_token, user_agent)
      @app.call(env)
    end

    def http_no_credential
      status = Constants::Error::Http::HTTP_NO_CREDENTIAL
      headers = {
        'Content-Type' => 'application/json',
        'x-dp-code' => status,
        'x_dp_msg' => '请求缺少身份信息.'
      }
      [status, headers, []]
    end

    def http_invalid_credential
      status = Constants::Error::Http::HTTP_INVALID_CREDENTIAL
      headers = {
        'Content-Type' => 'application/json',
        'x-dp-code' => status,
        'x_dp_msg' => '无效的请求身份.'
      }
      [status, headers, []]
    end

    def http_token_expired
      status = Constants::Error::Http::HTTP_TOKEN_EXPIRED
      headers = {
        'Content-Type' => 'application/json',
        'x-dp-code' => status,
        'x_dp_msg' => 'access token已失效.'
      }
      [status, headers, []]
    end
  end
end
