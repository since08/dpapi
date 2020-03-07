module V10
  module ThirdParty
    class LocationsController < ApplicationController
      def index
        options = params.slice(:keyword, :page, :pagetoken, :geo_type, :radius, :type)
        @locations = ::Geo::Location.nearby(params[:latitude], params[:longitude], options)
        render 'index'
      end
    end
  end
end
