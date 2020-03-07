class AddFreightToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :freight
    add_column :products, :freight_free, :boolean, default: false, comment: '是否免运费'
  end
end
