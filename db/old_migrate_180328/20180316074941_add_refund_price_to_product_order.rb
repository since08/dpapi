class AddRefundPriceToProductOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :product_orders,
               :refund_price,
               :decimal, precision: 8, scale: 2, default: 0, comment: '已退款的金额'
    add_column :product_orders,
               :refund_poker_coins,
               :integer, default: 0, comment: '已退的扑客币数量'
    add_column :product_refunds,
               :refund_poker_coins,
               :integer, default: 0, comment: '需要退的扑客币数量'
  end
end
