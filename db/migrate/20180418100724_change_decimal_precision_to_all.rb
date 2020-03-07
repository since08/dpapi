class ChangeDecimalPrecisionToAll < ActiveRecord::Migration[5.0]
  def change
    change_column :bills, :amount, :decimal, precision: 15, scale: 2, default: '0.0'

    change_column :crowdfunding_orders, :final_price, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :crowdfunding_orders, :deduction_price, :decimal, precision: 15, scale: 2, default: '0.0'

    change_column :crowdfunding_ranks, :deduct_tax, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :crowdfunding_ranks, :sale_amount, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :crowdfunding_ranks, :total_amount, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :crowdfunding_ranks, :platform_tax, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :crowdfunding_ranks, :unit_amount, :decimal, precision: 15, scale: 2, default: '0.0'

    change_column :poker_coin_discounts, :discount, :decimal, precision: 15, scale: 2, default: '0.0'

    change_column :product_order_items, :original_price, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :product_order_items, :price, :decimal, precision: 15, scale: 2, default: '0.0'

    change_column :product_orders, :shipping_price, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :product_orders, :total_product_price, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :product_orders, :total_price, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :product_orders, :final_price, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :product_orders, :deduction_price, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :product_orders, :refund_price, :decimal, precision: 15, scale: 2, default: '0.0'

    change_column :product_refunds, :refund_price, :decimal, precision: 15, scale: 2, default: '0.0'

    change_column :purchase_orders, :final_price, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :purchase_orders, :deduction_price, :decimal, precision: 15, scale: 2, default: '0.0'

    change_column :variants, :price, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :variants, :original_price, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :variants, :weight, :decimal, precision: 15, scale: 2, default: '0.0'
    change_column :variants, :volume, :decimal, precision: 15, scale: 2, default: '0.0'
  end
end
