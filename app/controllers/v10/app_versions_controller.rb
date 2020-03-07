module V10
  class AppVersionsController < ApplicationController
    def index
      @ios_platform = AppVersion.find_by(platform: :ios)
      @android_platform = AppVersion.find_by(platform: :android)
    end
  end
end
