module Services
  module Races
    class FilteredByWebService
      MAX_SEQ_ID = 10**20
      include Serviceable
      include Constants::Error::Common

      def initialize(search_params)
        @search_params = search_params
        @seq_id     = search_params[:seq_id].to_i
        @page_size  = search_params[:page_size]
        @date       = search_params[:date]
        @category   = search_params[:category]
      end

      def call
        return PurchasableRaceService.call(@search_params) if @category == 'on_sale'

        races = @category == 'upcoming' ? upcoming_races : desc_by_date_races
        ApiResult.success_with_data(races: races)
      end

      def upcoming_races
        resource.where('seq_id > ?', @seq_id).recent_races.seq_asc.limit(@page_size)
      end

      def desc_by_date_races
        seq_id = @seq_id.zero? ? MAX_SEQ_ID : @seq_id
        races = resource.where('seq_id < ?', seq_id).seq_desc.limit(@page_size)
        return races if @date == 'all' || @date.nil?

        races.where('begin_date <= ?', date_mapping(@date))
      end

      def date_mapping(date)
        @date_mapping ||= {
          week: 1.week.since,
          month: 1.month.since,
          '2018': '2018-12-31',
          '2017': '2017-12-31',
          '2016': '2016-12-31',
          long_ago: '2015-12-31'
        }
        @date_mapping[date.to_sym]
      end

      def resource
        @resource ||= Race.main
      end
    end
  end
end
