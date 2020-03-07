class AddProductToOrderItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :product_order_items, :product
  end
end
