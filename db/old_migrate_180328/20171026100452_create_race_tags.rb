class CreateRaceTags < ActiveRecord::Migration[5.0]
  def change
    create_table :race_tags do |t|
      t.string :name
      t.timestamps
    end
  end
end
