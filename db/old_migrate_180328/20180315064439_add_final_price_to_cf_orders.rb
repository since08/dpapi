class AddFinalPriceToCfOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :crowdfunding_orders,
               :final_price,
               :decimal, precision: 8, scale: 2, default: 0, comment: '最终付款的价格'
    add_column :crowdfunding_orders,
               :deduction_price,
               :decimal, precision: 8, scale: 2, default: 0, comment: '扑客币折扣的价格'

    add_column :product_orders,
               :final_price,
               :decimal, precision: 8, scale: 2, default: 0, comment: '最终付款的价格'
    add_column :product_orders,
               :deduction_price,
               :decimal, precision: 8, scale: 2, default: 0, comment: '扑客币折扣的价格'
  end
end
