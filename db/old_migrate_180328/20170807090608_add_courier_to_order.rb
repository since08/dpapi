class AddCourierToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_orders, :courier, :string, comment: '快递公司名称'
    add_column :purchase_orders, :tracking_no, :string, comment: '快递单号'
  end
end
