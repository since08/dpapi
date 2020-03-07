module Services
  module ShopOrders
    class PrePurchaseItems
      attr_reader :order_items
      attr_reader :invalid_order_items
      def initialize(variants, province = nil)
        @province = province
        @order_items = []
        @invalid_order_items = []

        variants.to_a.each do |variant|
          discern_items(variant)
        end
      end

      def discern_items(variant)
        obj = Variant.find_by(id: variant[:id])
        return @invalid_order_items << variant[:id] if obj.nil?

        return @invalid_order_items << obj.id unless obj.product.published?

        return @invalid_order_items << obj.id if variant[:number].to_i > obj.stock

        @order_items << ProductOrderItem.new(variant: obj, number: variant[:number].to_i)
      end

      def purchasable_check
        return '商品数量不足或已过期' if order_items.blank? && invalid_order_items.present?

        return '商品参数有误' if order_items.blank?

        order_items.each do |item|
          return '购买数量不能小于等于0' if item.number <= 0
          # next @invalid_order_items << item.variant.id unless item.variant.product.published?
          # next @invalid_order_items << item.variant.id if item.number > item.variant.stock
        end

        'ok'
      end

      def check_result
        @check_result ||= purchasable_check
      end

      def total_price
        total_product_price + shipping_price
      end

      def total_product_price
        @total_product_price ||= @order_items.inject(0) do |n, item|
          (item.variant.price * item.number) + n
        end
      end

      def freight_free?
        # 只要有一件商品包邮，所有商品包邮
        @freight_free ||= @order_items.any? { |item| item.variant.product.freight_free? }
      end

      def shipping_price
        return 0 if freight_free?

        @shipping_price ||= @order_items.map do |item|
          item.variant.product.freight_fee(@province, item.number)
        end.max
      end

      def save_to_order(order)
        @order_items.each do |item|
          save_order_item(item, order)
          item.variant.product.increase_sales_volume(item.number)
          item.variant.decrease_stock(item.number)

          next if item.variant.is_master?

          item.variant.product.master.decrease_stock(item.number)
        end
      end

      def save_order_item(item, order)
        item.product_order = order
        item.syn_variant
        item.save
      end
    end
  end
end
