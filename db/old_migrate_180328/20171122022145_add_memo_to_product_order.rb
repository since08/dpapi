class AddMemoToProductOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :product_orders, :memo, :string, comment: '用户备注'
  end
end
