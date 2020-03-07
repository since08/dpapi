class AddSevenDaysReturnToOrderItem < ActiveRecord::Migration[5.0]
  def change
    add_column :product_order_items, :seven_days_return, :boolean,
               default: false, comment: '是否支持7天退货'
  end
end
