class ChangeProductItemRefundedStat < ActiveRecord::Migration[5.0]
  def change
    remove_column :product_order_items, :refunded
    add_column :product_order_items, :refund_status, :string, default: 'none', comment: 'none, open, close, completed'
  end
end
