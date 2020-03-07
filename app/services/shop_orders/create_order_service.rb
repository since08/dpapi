# rubocop:disable Metrics/MethodLength
module Services
  module ShopOrders
    class CreateOrderService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Order

      # {
      #   "variants":[
      #                {
      #                  "id":3,
      #                  "number":2
      #                },
      #                {
      #                  "id":3,
      #                  "number":2
      #                }
      #              ],
      #   "shipping_info":{
      #     "name":"收货人",
      #     "mobile":"134287222",
      #     "address":{
      #       "province":"广东省",
      #       "city":"深圳市",
      #       "area":"福田区",
      #       "detail":"卓越世纪中心3号楼"
      #     }
      #   },
      #   "memo":"这是一个备注"
      # }
      def initialize(user, params)
        @user   = user
        @params = params
        @shipping_info = params[:shipping_info] || {}
      end

      def call
        return ApiResult.error_result(MISSING_PARAMETER) if shipping_info_invalid?

        @pre_purchase_items = PrePurchaseItems.new(@params[:variants], @shipping_info[:address][:province])
        if @pre_purchase_items.check_result != 'ok'
          return ApiResult.error_result(INVALID_ORDER, @pre_purchase_items.check_result)
        end

        order = create_product_order

        # 判断是否需要使用扑客币抵扣 ricky-2018-03-13
        if @params[:deduction] || @params[:deduction].eql?('true')
          deduction_poker_coins = deduction_numbers(order.total_product_price).to_i
          Rails.logger.info "shop: deduction_poker_coins-> #{deduction_poker_coins}"
          unless @params[:deduction_numbers].to_i.eql?(deduction_poker_coins)
            return ApiResult.error_result(DEDUCTION_ERROR)
          end
          deduction_price = deduction_poker_coins.to_f / 100
          order.update(deduction: true,
                       deduction_numbers: deduction_poker_coins,
                       deduction_price: deduction_price,
                       final_price: order.final_price - deduction_price)

          # 将用户的扑客币冻结 扣除掉
          PokerCoin.deduction(order, '商品订单抵扣扑客币', order.deduction_numbers)
          order.deduction_success
        end

        @pre_purchase_items.save_to_order(order)
        create_product_shipping(order)
        ApiResult.success_with_data(order: order)
      end

      def create_product_shipping(order)
        address = @shipping_info[:address]
        ProductShippingAddress.create(product_order: order,
                                      name: @shipping_info[:name],
                                      mobile: @shipping_info[:mobile],
                                      province: address[:province],
                                      city: address[:city],
                                      area: address[:area],
                                      address: address[:detail])
      end

      def create_product_order
        @user.product_orders.create(status: 'unpaid',
                                    pay_status: 'unpaid',
                                    shipping_price: @pre_purchase_items.shipping_price,
                                    total_product_price: @pre_purchase_items.total_product_price,
                                    total_price: @pre_purchase_items.total_price,
                                    freight_free: @pre_purchase_items.freight_free?,
                                    final_price: @pre_purchase_items.total_price,
                                    memo: @params[:memo])
      end

      def shipping_info_invalid?
        [:name, :mobile, :address].each do |keyword|
          return true if @shipping_info[keyword].blank?
        end

        [:province, :city, :area, :detail].each do |keyword|
          return true if @shipping_info[:address][keyword].blank?
        end

        false
      end

      def deduction_numbers(total_price)
        user_account = @user.counter.total_poker_coins
        max_deduction = total_price * 100 * PokerCoinDiscount.first.discount
        Rails.logger.info "shop model: user_account-> #{user_account}, max_deduction-> #{max_deduction}"
        user_account > max_deduction ? max_deduction : user_account
      end
    end
  end
end
