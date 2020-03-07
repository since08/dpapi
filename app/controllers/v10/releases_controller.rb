module V10
  class ReleasesController < ApplicationController
    def index
      @releases = Release.all
    end
  end
end

