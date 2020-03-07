module Services
  module ShopOrders
    class CreateRefundService
      include Serviceable
      include Constants::Error::Order

      def initialize(params, order_items, refund_type, order)
        @params = params
        @order = order
        @order_items = order_items
        @refund_type = refund_type
      end

      def call
        return ApiResult.error_result(OVER_REFUND_TIME) unless @order.could_refund?
        return ApiResult.error_result(CANNOT_REFUND) unless could_refund?
        return ApiResult.error_result(SEVEN_DAYS_REFUND_ERROR) unless seven_days_return?
        return ApiResult.error_result(CANNOT_REFUND) unless @order.could_refund_poker_coins?
        return ApiResult.error_result(INVALID_REFUND_PRICE) unless input_valid?
        refund_record = create_refund
        create_detail(refund_record)
        create_refund_images(refund_record)
        @order_items.each(&:open_refund)
        ApiResult.success_with_data(refund_record: refund_record)
      end

      private

      def create_refund
        refund_price = refund_cash_numbers
        rest_price = @params[:refund_price].to_f - refund_price
        refund_poker_coins = refund_poker_numbers(rest_price)
        ProductRefund.create(product_order: @order,
                             product_refund_type: @refund_type,
                             refund_price: refund_price,
                             refund_poker_coins: refund_poker_coins,
                             memo: @params[:memo])
      end

      def refund_cash_numbers
        return 0 unless @order.could_refund_cash?
        if @params[:refund_price].to_f <= @order.could_refund_cash_numbers
          @params[:refund_price].to_f
        else
          @order.could_refund_cash_numbers
        end
      end

      def refund_poker_numbers(rest_price)
        if rest_price * 100 >= @order.could_refund_poker_numbers
          @order.could_refund_poker_numbers
        else
          rest_price * 100
        end
      end

      def create_detail(refund_record)
        @order_items.each do |item|
          refund_record.product_refund_details.create(product_order_item: item)
        end
      end

      def create_refund_images(refund_record)
        return if @params[:refund_images].blank?
        @params[:refund_images].each do |item|
          temp_image = TmpImage.find_by(id: item[:id])
          next if temp_image.blank?
          ProductRefundImage.create(product_refund: refund_record, remote_image_url: temp_image.image_path, memo: item[:content])
          remove_tmp_image(temp_image)
        end
      end

      def seven_days_return?
        # 只要有一个不是7天退换货，就返回false
        !@order_items.pluck(:seven_days_return).include?(false)
      end

      def could_refund?
        # 如果有一个商品不可退款，就不可以退
        !@order_items.collect(&:could_refund?).include?(false)
      end

      # def current_items_price
      #   total_item_price = 0
      #   @order_items.each do |item|
      #     total_item_price += item.price * item.number
      #   end
      #   total_item_price
      # end

      def input_valid?
        could_refund = @order.total_price - @order.refund_price
        @params[:refund_price].to_f.positive? && @params[:refund_price].to_f <= could_refund
      end

      def remove_tmp_image(image)
        image.destroy!
      end
    end
  end
end