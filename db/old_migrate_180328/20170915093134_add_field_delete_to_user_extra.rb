class AddFieldDeleteToUserExtra < ActiveRecord::Migration[5.0]
  def change
    add_column :user_extras, :is_delete, :integer, default: '0', comment: '0未删除 1删除'
    add_index :user_extras, :is_delete
  end
end
