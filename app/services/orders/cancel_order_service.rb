module Services
  module Orders
    class CancelOrderService
      include Serviceable
      include Constants::Error::Order
      attr_accessor :order, :user

      def initialize(order, user)
        self.order = order
        self.user  = user
      end

      def call
        return error_result(CANNOT_CANCEL) unless order.status == 'unpaid'

        order.update(status: 'canceled')
        if order.ticket_type == 'e_ticket'
          order.ticket.return_a_e_ticket
        else
          order.ticket.return_a_entity_ticket
        end

        # # 将扑客币的数量添加上去
        if order.deduction && order.deduction_result.eql?('success')
          PokerCoin.deduction(order, '赛事订单返还扑客币', order.deduction_numbers, '+')
          order.deduction_success
        end

        ApiResult.success_result
      end
    end
  end
end
