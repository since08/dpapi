class CreateUserCounters < ActiveRecord::Migration[5.0]
  def change
    create_table :user_counters do |t|
      t.references :user
      t.decimal :total_poker_coins, precision: 8, scale: 2, default: 0, comment: '扑客币换成浮点数'
      t.timestamps
    end
    generate_counter if UserCounter.count.zero?
  end

  def generate_counter
    User.unscoped.collect do |user|
      UserCounter.create(user: user)
    end
  end
end
