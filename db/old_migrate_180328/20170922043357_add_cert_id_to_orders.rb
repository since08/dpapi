class AddCertIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :purchase_orders, :user_extra
  end
end
