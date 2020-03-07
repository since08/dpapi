class AddLoginIpToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_login_ip, :string, default: '', comment: '上次登录ip'
    add_column :users, :current_login_ip, :string, default: '', comment: '最新登录ip'
  end
end
