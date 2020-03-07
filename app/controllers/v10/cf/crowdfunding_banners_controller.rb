module V10
  module Cf
    class CrowdfundingBannersController < ApplicationController
      def index
        @banners = Banner.crowdfunding_published.default_order
        render 'v10/homepage/banners/index'
      end
    end
  end
end
