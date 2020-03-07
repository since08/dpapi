class AddPokerCoinsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :crowdfunding_orders,
               :poker_coins,
               :decimal, precision: 8, scale: 2, default: 0, comment: '获得扑客币数量'
  end
end
