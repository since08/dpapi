class CreateUserTagMaps < ActiveRecord::Migration[5.0]
  def change
    create_table :user_tag_maps do |t|
      t.references :user
      t.references :user_tag
      t.timestamps
    end
    remove_column :users, :tag
  end
end
