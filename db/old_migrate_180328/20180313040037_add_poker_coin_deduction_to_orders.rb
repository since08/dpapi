class AddPokerCoinDeductionToOrders < ActiveRecord::Migration[5.0]
  def change
    add_crowdfunding_order_field
    add_product_orders_field
    add_purchase_orders_field
  end

  def add_crowdfunding_order_field
    add_column :crowdfunding_orders,
               :deduction,
               :boolean, default: false, comment: '是否使用扑客币抵扣'
    add_column :crowdfunding_orders,
               :deduction_numbers,
               :integer, default: 0, comment: '抵扣的扑客币数量'
    add_column :crowdfunding_orders,
               :deduction_result,
               :string, default: 'init', comment: '扑客币的抵扣状态，init，success，failed'
  end

  def add_product_orders_field
    add_column :product_orders,
               :deduction,
               :boolean, default: false, comment: '是否使用扑客币抵扣'
    add_column :product_orders,
               :deduction_numbers,
               :integer, default: 0, comment: '抵扣的扑客币数量'
    add_column :product_orders,
               :deduction_result,
               :string, default: 'init', comment: '扑客币的抵扣状态，init，success，failed'
  end

  def add_purchase_orders_field
    add_column :purchase_orders,
               :deduction,
               :boolean, default: false, comment: '是否使用扑客币抵扣'
    add_column :purchase_orders,
               :deduction_numbers,
               :integer, default: 0, comment: '抵扣的扑客币数量'
    add_column :purchase_orders,
               :deduction_result,
               :string, default: 'init', comment: '扑客币的抵扣状态，init，success，failed'
  end
end
