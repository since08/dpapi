# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/MethodLength
module Services
  module Orders
    class CreateOrderService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Race
      include Constants::Error::Account
      include Constants::Error::Order

      TICKET_TYPES = %w(e_ticket entity_ticket).freeze
      TICKET_STATUS_ERRORS = {
        unsold: TICKET_UNSOLD,
        end: TICKET_END,
        sold_out: TICKET_SOLD_OUT
      }.freeze
      cattr_accessor :lock_retry_times
      self.lock_retry_times = 2
      delegate :ticket_info, to: :@ticket

      def initialize(race, ticket, user, params)
        @race   = race
        @ticket = ticket
        @user   = user
        @params = params
        @invite_code = params[:invite_code]&.strip&.upcase
        # 兼容老版本不传cert_it的情况，
        if params[:cert_id].blank?
          return @user_extra = UserExtra.find_by!(user_id: @user.id)
        end
        @user_extra = @user.user_extras.find(params[:cert_id])
      end

      def call
        unless @params[:ticket_type].in? TICKET_TYPES
          return ApiResult.error_result(UNSUPPORTED_TYPE)
        end

        unless @race.ticket_sellable
          return ApiResult.error_result(TICKET_NO_SELL)
        end

        unless @ticket.status == 'selling'
          return ApiResult.error_result(TICKET_STATUS_ERRORS[@ticket.status.to_sym])
        end

        ##
        # 放开购买次数限制
        # if PurchaseOrder.purchased?(@user.id, @race.id)
        #   return ApiResult.error_result(AGAIN_BUY)
        # end

        send("ordering_#{@params[:ticket_type]}")
      end

      def ordering_e_ticket
        unless UserValidator.email_valid?(@params[:email].strip)
          return ApiResult.error_result(PARAM_FORMAT_ERROR)
        end

        result = stale_ticket_info_retries { sold_a_e_ticket }
        return result if result.failure?

        order = PurchaseOrder.new(init_order_params)
        confirm_order order
      end

      def ordering_entity_ticket
        [:mobile, :address, :consignee].each do |keyword|
          return ApiResult.error_result(MISSING_PARAMETER) if @params[keyword].blank?
        end

        result = stale_ticket_info_retries { sold_a_entity_ticket }
        return result if result.failure?

        order = PurchaseOrder.new(init_order_params)
        confirm_order order
      end

      def confirm_order(order)
        # 4 判断是否需要用到扑客币抵扣
        deduction_flag = @params[:deduction] || @params[:deduction].eql?('true')

        if deduction_flag
          deduction_numbers = order.max_deduction_poker_coins.to_i
          Rails.logger.info "race: deduction_numbers-> #{deduction_numbers}"
          unless @params[:deduction_numbers].to_i.eql?(deduction_numbers)
            return ApiResult.error_result(DEDUCTION_ERROR)
          end
          order.deduction = true
          order.deduction_numbers = deduction_numbers
          order.deduction_price = deduction_numbers.to_f / 100
          order.final_price = order.price - order.deduction_price
        end

        ApiResult.error_result(SYSTEM_ERROR) unless order.save

        if deduction_flag
          # 将用户的扑客币冻结 扣除掉
          PokerCoin.deduction(order, '赛票订单抵扣扑客币', order.deduction_numbers)
          order.deduction_success
        end

        ApiResult.success_with_data(order: order)
      end

      def stale_ticket_info_retries
        optimistic_lock_retry_times = self.class.lock_retry_times
        begin
          yield
        rescue ActiveRecord::StaleObjectError
          optimistic_lock_retry_times -= 1
          return ApiResult.error_result(SYSTEM_ERROR) if optimistic_lock_retry_times.negative?

          ticket_info.reload(lock: true)
          retry
        end
      end

      def sold_a_e_ticket
        if ticket_info.e_ticket_sold_out?
          return ApiResult.error_result(E_TICKET_SOLD_OUT)
        end

        ticket_info.increment_with_lock!(:e_ticket_sold_number)
        @ticket.update(status: 'sold_out') if ticket_info.sold_out?
        ApiResult.success_result
      end

      def sold_a_entity_ticket
        if ticket_info.entity_ticket_sold_out?
          return ApiResult.error_result(ENTITY_TICKET_SOLD_OUT)
        end

        ticket_info.increment_with_lock!(:entity_ticket_sold_number)
        @ticket.update(status: 'sold_out') if ticket_info.sold_out?
        ApiResult.success_result
      end

      def discount_price
        code_info = InviteCode.find_by(code: @invite_code)
        # return @ticket.price if code_info.nil? || code_info.no_discount? || code_info.coupon_number.zero?
        if code_info&.rebate?
          return @ticket.price * (code_info.coupon_number / 100.to_f)
        end

        return (@ticket.price - code_info.coupon_number) if code_info&.reduce?

        @ticket.price
      end

      def init_order_params
        {
          user:           @user,
          race:           @race,
          ticket:         @ticket,
          user_extra:     @user_extra,
          price:          discount_price,
          original_price: @ticket.original_price,
          final_price:    discount_price,
          ticket_type:    @params[:ticket_type],
          email:          @params[:email],
          mobile:         @params[:mobile],
          consignee:      @params[:consignee],
          address:        @params[:address],
          invite_code:    @invite_code,
          status:         'unpaid'
        }
      end
    end
  end
end