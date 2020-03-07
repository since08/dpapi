class AddCompletedTimeToProductOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :product_orders, :completed_time, :datetime, comment: '确认收货时间'
    add_column :product_orders, :deleted, :boolean, default: false, comment: '是否删除'
  end
end
