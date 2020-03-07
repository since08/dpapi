class CreateRaceTagMaps < ActiveRecord::Migration[5.0]
  def change
    create_table :race_tag_maps do |t|
      t.references :race_tag
      t.references :data, polymorphic: true, index: true
      t.timestamps
    end
  end
end
