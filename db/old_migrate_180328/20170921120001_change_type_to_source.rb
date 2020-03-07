class ChangeTypeToSource < ActiveRecord::Migration[5.0]
  def change
    rename_column :reply_templates, :type, :source
  end
end
