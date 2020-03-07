class AddDefaultToUserExtra < ActiveRecord::Migration[5.0]
  def change
    add_column :user_extras, :default, :boolean, default: false, comment: '是否默认'
  end
end