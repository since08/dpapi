class AddTotalMoneyToCount < ActiveRecord::Migration[5.0]
  def change
    add_column :crowdfunding_player_counters, :total_money, :integer,
               default: 0,
               comment: '支付的总价格'
  end
end
