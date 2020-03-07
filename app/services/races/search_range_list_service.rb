# rubocop:disable Metrics/MethodLength
module Services
  module Races
    class SearchRangeListService
      include Serviceable
      include Constants::Error::Common
      attr_accessor :search_params, :user_uuid

      def initialize(user_uuid, search_params)
        self.search_params = search_params
        self.user_uuid = user_uuid
      end

      def main_race
        Race.main
      end

      def call
        begin_date = search_params[:begin_date]
        end_date = search_params[:end_date]
        user = User.by_uuid(user_uuid)
        # 传递过来的begin_date <= 数据库中的begin_date <= 传递过来的end_date
        race_begin = main_race.select('id, begin_date, end_date')
                              .where('begin_date >= ?', begin_date)
                              .where('begin_date <= ?', end_date)
                              .order(created_at: :asc)
        race_begin_ids = race_begin.pluck(:id).blank? ? [0] : race_begin.pluck(:id)

        # 传递过来的begin_date <= 数据库中的end_date <= 传递过来的end_date, 但是排除掉上面已经查出来的
        race_end = main_race.select('id, begin_date, end_date')
                            .where('end_date >= ?', begin_date)
                            .where('end_date <= ?', end_date)
                            .where('id not in (?)', race_begin_ids)
                            .order(created_at: :asc)
        race_end_ids = race_end.pluck(:id)
        expect_ids = race_begin_ids + race_end_ids

        race_include = main_race.select('id, begin_date, end_date')
                                .where('begin_date <= ?', begin_date)
                                .where('end_date >= ?', end_date)
                                .where('id not in (?)', expect_ids)
                                .order(created_at: :asc)

        # 合并得到传递过来的区间存在的赛事列表
        race_all = (race_begin + race_end + race_include).sort_by { |v| v[:begin_date] }

        # 向赛事列表里面添加赛事的关注情况
        race_lists = race_all.collect do |race|
          follows = RaceFollow.followed?(user.try(:id), race.id) ? 1 : 0
          orders = PurchaseOrder.purchased?(user.try(:id), race.id) ? 1 : 0
          {
            begin_date: race.begin_date,
            end_date: race.end_date,
            follows: follows,
            orders: orders
          }
        end
        list_result = {}
        (begin_date..end_date).each do |date|
          list_result[date] = { date: date, follows: 0, orders: 0, counts: 0 }

          race_lists.each do |item|
            # rubocop:disable Style/Next:61
            if date >= item[:begin_date].to_s && date <= item[:end_date].to_s
              list_result[date][:counts] += 1
              list_result[date][:follows] += item[:follows]
              list_result[date][:orders] += item[:orders]
            end
          end
        end
        ApiResult.success_with_data(race: list_result)
      end
    end
  end
end
