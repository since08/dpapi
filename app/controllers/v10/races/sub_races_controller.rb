module V10
  module Races
    class SubRacesController < ApplicationController
      before_action :set_race, only: [:index]

      def index
        if params[:type] == 'tradable'
          @sub_races = @race.sub_races.joins(:tickets)
                            .where("#{Ticket.table_name}": { status: %w(selling sold_out) })
                            .ticket_sellable
                            .distinct
        else
          @sub_races = @race.sub_races.date_asc
        end
      end

      def show
        @sub_race = Race.find(params[:id])
      end

      def set_race
        @race = Race.find(params[:race_id])
      end
    end
  end
end
