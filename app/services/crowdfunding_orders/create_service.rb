# rubocop:disable Metrics/MethodLength
module Services
  module CrowdfundingOrders
    class CreateService
      include Serviceable
      include Constants::Error::Order

      def initialize(user, user_extra, cf_player, params)
        @user = user
        @user_extra = user_extra
        @cf_player = cf_player
        @number = params[:number]
        @params = params
      end

      def call
        # 1 查看该用户是否有购买过
        # 2 购买的分数是否超出限购的份数
        # 3 判断是否超过截止日期
        return ApiResult.error_result(OUTDATE) if Time.zone.today >= @cf_player.crowdfunding.expire_date
        return ApiResult.error_result(LIMIT_PAY) if limit?

        total_money = @number * @cf_player.stock_unit_price
        order = CrowdfundingOrder.new(user: @user,
                                      user_extra: @user_extra,
                                      crowdfunding_player: @cf_player,
                                      crowdfunding: @cf_player.crowdfunding,
                                      order_stock_number: @number,
                                      order_stock_money: @cf_player.stock_unit_price,
                                      total_money: total_money,
                                      final_price: total_money)
        # 4 判断是否需要用到扑客币抵扣
        if @params[:deduction] || @params[:deduction].eql?('true')
          deduction_numbers = order.max_deduction_poker_coins.to_i
          Rails.logger.info "cf_order: deduction_numbers-> #{deduction_numbers}"
          unless @params[:deduction_numbers].to_i.eql?(deduction_numbers)
            return ApiResult.error_result(DEDUCTION_ERROR)
          end
          order.deduction = true
          order.deduction_numbers = deduction_numbers
          order.deduction_price = deduction_numbers.to_f / 100
          order.final_price = order.total_money - order.deduction_price
        end

        order.save!
        ApiResult.success_with_data(order: order)
      end

      def limit?
        # 如果限购份数为0，表示不限购
        return false if @cf_player.limit_buy.zero?
        (@number + past_buy_number) > @cf_player.limit_buy
      end

      def past_buy_number
        CrowdfundingOrder.past_buy_number(@cf_player, @user)
      end
    end
  end
end
