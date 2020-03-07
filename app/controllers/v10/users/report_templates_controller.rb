module V10
  module Users
    class ReportTemplatesController < ApplicationController
      include UserAccessible
      before_action :login_required

      def index
        @templates = ReportTemplate.all
      end
    end
  end
end

