class AddDeliveredTimeToProductOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :product_orders, :delivered_time, :datetime, comment: '发货时间'
  end
end
