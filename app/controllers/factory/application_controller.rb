module Factory
  class ApplicationController < ::ApplicationController
    include Constants::Error::Common
    before_action :data_clear, if: :clear?

    def data_clear
      return if Rails.env.production?

      DatabaseCleaner.strategy = :truncation, { except: %w(affiliates affiliate_apps) }
      DatabaseCleaner.clean
      Rails.cache.clear
    end

    def clear
      data_clear
      render_api_success
    end

    def create
      ac = params.delete(:ac) || ''
      result = AcCreator.call(ac, params)
      if result
        render_api_success
      else
        render_api_error(MISSING_PARAMETER)
      end
    end

    def clear?
      params.delete(:clear) == 'true'
    end
  end
end
