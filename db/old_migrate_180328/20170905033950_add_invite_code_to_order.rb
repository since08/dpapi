class AddInviteCodeToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_orders, :invite_code, :string, comment: '用户填写的邀请码'
  end
end
