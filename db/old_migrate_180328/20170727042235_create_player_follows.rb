class CreatePlayerFollows < ActiveRecord::Migration[5.0]
  def change
    create_table :player_follows do |t|
      t.references :user
      t.references :player
      t.timestamps
    end
  end
end
