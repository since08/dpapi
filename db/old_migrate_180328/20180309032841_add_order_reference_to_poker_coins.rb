class AddOrderReferenceToPokerCoins < ActiveRecord::Migration[5.0]
  def change
    add_reference :poker_coins, :orderable, polymorphic: true, comment: '记录扑客币的去向'
  end
end
