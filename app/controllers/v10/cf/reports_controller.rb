module V10
  module Cf
    class ReportsController < ApplicationController
      before_action :set_crowdfunding
      def index
        @reports = @crowdfunding.crowdfunding_reports.page(params[:page]).per(params[:page_size])
      end

      private

      def set_crowdfunding
        @crowdfunding = Crowdfunding.published.find(params[:crowdfunding_id])
      end
    end
  end
end

