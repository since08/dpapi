class AddWxAvatarToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :wx_avatar, :string
  end
end
