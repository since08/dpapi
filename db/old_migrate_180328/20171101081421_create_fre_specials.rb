class CreateFreSpecials < ActiveRecord::Migration[5.0]
  def change
    create_table :fre_specials do |t|
      t.references :freight
      t.integer :first_cond
      t.decimal :first_price, precision: 5, scale: 2
      t.integer :add_cond
      t.decimal :add_price, precision: 5, scale: 2
      t.timestamps
    end
  end
end
