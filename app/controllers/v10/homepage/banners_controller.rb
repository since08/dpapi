module V10
  module Homepage
    class BannersController < ApplicationController
      def index
        @banners = Banner.homepage_published.default_order
      end
    end
  end
end