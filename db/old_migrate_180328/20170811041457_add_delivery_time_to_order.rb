class AddDeliveryTimeToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_orders, :delivery_time, :datetime, comment: '发货时间'
  end
end
