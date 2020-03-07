class ChangeSourceToTypeId < ActiveRecord::Migration[5.0]
  def change
    remove_column :reply_templates, :source
    add_column :reply_templates, :type_id, :integer
  end
end
