class CreateFreights < ActiveRecord::Migration[5.0]
  def change
    create_table :freights do |t|
      t.string  :name
      t.integer :first_cond
      t.decimal :first_price, precision: 5, scale: 2
      t.integer :add_cond
      t.decimal :add_price, precision: 5, scale: 2
      t.boolean :default, default: false, comment: '是否默认'
      t.string  :freight_type, default: '', comment: '类型'
      t.timestamps
    end
  end
end
