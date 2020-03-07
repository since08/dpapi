class DeleteProductOrderName < ActiveRecord::Migration[5.0]
  def change
    remove_column :product_orders, :name
  end
end
