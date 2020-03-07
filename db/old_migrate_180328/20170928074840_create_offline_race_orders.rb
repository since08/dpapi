class CreateOfflineRaceOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :offline_race_orders do |t|
      t.references :invite_code
      t.string :mobile
      t.string :email
      t.string :name
      t.string :ticket
      t.integer :price
      t.timestamps
    end
  end
end
