class OptimizeProductOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :product_orders, :freight_free, :boolean,
               default: false, comment: '是否免运费'

    add_index :product_orders, :order_number
  end
end
