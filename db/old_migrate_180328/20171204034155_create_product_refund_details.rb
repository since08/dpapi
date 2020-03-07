class CreateProductRefundDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :product_refund_details do |t|
      t.references :product_order_item
      t.references :product_refund
      t.timestamps
    end
  end
end
