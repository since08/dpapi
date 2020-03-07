module V10
  module Races
    class RaceRanksController < ApplicationController
      before_action :set_race, only: [:index]

      def index; end

      def set_race
        @race = Race.find(params[:race_id])
      end
    end
  end
end
