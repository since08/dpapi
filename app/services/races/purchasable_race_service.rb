module Services
  module Races
    class PurchasableRaceService
      include Serviceable

      def initialize(search_params)
        @seq_id     = search_params[:seq_id].to_i
        @page_size  = search_params[:page_size]
        @keyword    = search_params[:keyword]
      end

      def call
        races = if @keyword.blank?
                  purchasable_races
                else
                  with_keyword_races
                end
        races = races.where("#{Race.table_name}.seq_id > ?", @seq_id).limit(@page_size).seq_asc
        ApiResult.success_with_data(races: races)
      end

      def purchasable_races
        # Race.left_joins(:sub_races)
        #     .where(parent_id: 0)
        #     .where('races.ticket_sellable = ? or sub_races_races.ticket_sellable = ?', 1, 1)
        #     .distinct
        Race.main.ticket_sellable
      end

      def with_keyword_races
        like_sql = "#{Race.table_name}.name like ? or #{Race.table_name}.location like ?"
        purchasable_races.where(like_sql, "%#{@keyword}%", "%#{@keyword}%")
      end
    end
  end
end
