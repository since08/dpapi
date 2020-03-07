require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

require File.expand_path('../../lib/middlewares/api_request_credential', __FILE__)
require File.expand_path('../../lib/middlewares/switch_table_lang', __FILE__)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
# load .env
Dotenv::Railtie.load
module Dpapi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # my config
    # set time zone to Beijing
    config.time_zone = 'Beijing'

    config.middleware.delete Rack::ETag
    config.middleware.insert_before Rack::Head, DpAPI::ApiRequestCredential
    config.middleware.insert_after DpAPI::ApiRequestCredential, DpAPI::SwitchTableLang
    config.active_job.queue_adapter = :resque

    # auto_load
    config.autoload_paths += [
        Rails.root.join('lib')
    ]

    # eager_load
    config.eager_load_paths += [
        Rails.root.join('lib/qcloud'),
        Rails.root.join('lib/dp_push'),
        Rails.root.join('lib/geo/**')
    ]

    config.i18n.default_locale = 'zh-CN'

    # config.middleware.use Rack::Attack
  end
end
