class AddFieldToWeixinUser < ActiveRecord::Migration[5.0]
  def change
    add_column :weixin_users, :access_token, :string
    add_column :weixin_users, :expires_in, :string
    add_column :weixin_users, :refresh_token, :string
  end
end
