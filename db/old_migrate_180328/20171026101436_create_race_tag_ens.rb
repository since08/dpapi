class CreateRaceTagEns < ActiveRecord::Migration[5.0]
  def change
    create_table :race_tag_ens do |t|
      t.string :name
      t.timestamps
    end
  end
end
