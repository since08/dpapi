class CreatePokerCoinDiscounts < ActiveRecord::Migration[5.0]
  def change
    create_table :poker_coin_discounts do |t|
      t.decimal :discount, precision: 3, scale: 2, default: 0, comment: '扑客币换成浮点数'
      t.timestamps
    end
  end
end

