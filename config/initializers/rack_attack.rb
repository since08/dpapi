class Rack::Attack
  BLOCK_MESSAGE = '你请求过快，超过了频率限制，暂时屏蔽一段时间。'.freeze

  Rack::Attack.cache.store = Rails.cache

  throttle('req/ip', limit: 200, period: 1.minute) do |req|
    req.ip
  end

  blocklist('blacklist/ip') do |req|
    ENV["BLACK_IPS"] && ENV["BLACK_IPS"].split(',').collect(&:strip).include?(req.ip)
  end

  # 允许 localhost
  safelist('allow from localhost') do |req|
    '127.0.0.1' == req.ip || '::1' == req.ip
  end

  ### Custom Throttle Response ###
  self.throttled_response = lambda do |_env|
    [503, { 'dp-error-message' => BLOCK_MESSAGE }, []]
  end
end