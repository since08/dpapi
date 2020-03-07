source 'https://gems.ruby-china.com'

git_source(:github) do |repo_name|
  repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
  'https://github.com/#{repo_name}.git'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'jbuilder'

#cache
gem 'redis', '~> 3.2'
gem 'hiredis'
gem 'redis-rails', '~> 5.0', '>= 5.0.2'
gem 'second_level_cache', '~> 2.3.0'
gem 'request_store'
gem 'leaderboard'
# gem 'connection_pool', '~> 2.2', '>= 2.2.1'

# 文件处理组件
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
# gem 'carrierwave-ucloud', '~> 0.0.2'
gem 'carrierwave-upyun'
gem 'dotenv-rails'

gem 'jwt'
gem 'resque'

# 压缩图片
gem 'image_optim'
gem 'image_optim_pack'
gem 'carrierwave-imageoptim'

gem 'jpush', '~> 4.0', '>= 4.0.6'
gem 'awesome_nested_set' # 无限分类

gem 'faraday'

# Apm
# gem 'oneapm_rpm', '~> 1.4.0'
gem 'newrelic_rpm'

# rack-attack
gem 'rack-attack'

# 易联支付
gem 'yl_pay'

# 微信支付
gem 'wx_pay'

# 分页
gem 'kaminari'

# 微信登录
gem 'weixin_authorize'

# 物流查询接口
gem 'kuaidiniao'

# 极光IM gem
gem 'jmessage'

# 附近的人
gem 'geocoder'

gem 'rollbar'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'rubocop', require: false
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
  gem 'capistrano-resque', require: false
  gem 'awesome_print'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'simplecov', require: false, group: :test

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :tools do
  gem 'rails-erd', require: false
end
