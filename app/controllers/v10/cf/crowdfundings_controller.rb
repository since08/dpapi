module V10
  module Cf
    class CrowdfundingsController < ApplicationController
      def index
        @crowdfundings = Crowdfunding.published.sorted.page(params[:page]).per(params[:page_size])
      end

      def show
        @crowdfunding = Crowdfunding.published.find(params[:id])
        @crowdfunding.increase_page_views
      end
    end
  end
end
