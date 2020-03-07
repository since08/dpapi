module Services
  module Races
    class SearchByKeywordService
      include Serviceable
      include Constants::Error::Common

      def initialize(search_params)
        @user_uuid  = search_params[:u_id]
        @page_size  = search_params[:page_size]
        @keyword    = search_params[:keyword]
      end

      def call
        races = with_keyword_races(main_race)
                .limit(@page_size)
                .begin_date_desc
        ApiResult.success_with_data(races: races, user: User.by_uuid(@user_uuid))
      end

      def with_keyword_races(races)
        races.where('name like ? or location like ?', "%#{@keyword}%", "%#{@keyword}%")
      end

      def main_race
        Race.main
      end
    end
  end
end
