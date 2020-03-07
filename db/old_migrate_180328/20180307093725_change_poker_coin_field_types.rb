class ChangePokerCoinFieldTypes < ActiveRecord::Migration[5.0]
  def change
    change_column :crowdfunding_orders, :poker_coins, :integer, default: 0, comment: '扑客币更换为整形'
    change_column :user_counters, :total_poker_coins, :integer, default: 0, comment: '扑客币更换为整形'
    change_column :poker_coins, :number, :integer, default: 0, comment: '扑客币更换为整形'
  end
end
