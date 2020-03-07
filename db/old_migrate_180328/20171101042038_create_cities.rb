class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :city_id
      t.string :name
      t.string :province_id
    end
  end
end
