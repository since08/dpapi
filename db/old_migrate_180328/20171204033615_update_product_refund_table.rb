class UpdateProductRefundTable < ActiveRecord::Migration[5.0]
  def change
    add_reference :product_refunds, :product_order
    remove_reference :product_refunds, :product_order_item
  end
end
