module V10
  module Homepage
    class HeadlinesController < ApplicationController
      def index
        @headlines = Headline.published.default_order
      end
    end
  end
end