class AddUserExtraToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :crowdfunding_orders, :user_extra
  end
end
