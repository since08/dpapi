class ChangeTypeNameToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :product_type, :string, default: 'entity', comment: 'entity 实物， virtual 虚拟物品'
    remove_column(:products, :type)
  end
end
