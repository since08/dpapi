class CreateVideoGroupEns < ActiveRecord::Migration[5.0]
  def change
    create_table :video_group_ens do |t|
      t.string :name
      t.timestamps
    end
  end
end
