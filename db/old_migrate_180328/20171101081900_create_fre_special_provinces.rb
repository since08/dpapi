class CreateFreSpecialProvinces < ActiveRecord::Migration[5.0]
  def change
    create_table :fre_special_provinces do |t|
      t.references :fre_special
      t.references :province
      t.string :province_name
      t.timestamps
    end
  end
end
