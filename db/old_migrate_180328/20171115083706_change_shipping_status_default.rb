class ChangeShippingStatusDefault < ActiveRecord::Migration[5.0]
  def change
    remove_column :product_orders, :shipping_status
    add_column :product_orders, :delivered, :boolean, default: false
    remove_column :product_order_items, :shipping_status
    add_column :product_order_items, :refunded, :boolean, default: false
  end
end
