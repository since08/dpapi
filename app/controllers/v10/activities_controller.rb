module V10
  class ActivitiesController < ApplicationController
    def index
      @activities = Activity.order(activity_time: :desc).limit(50)
    end

    def show
      @activity = Activity.find(params[:id])
    end

    def pushed
      @activity = Activity.where('start_push <= :current AND end_push >= :current', current: Time.now)
                          .find_by!(pushed: true)
      render 'show'
    end
  end
end