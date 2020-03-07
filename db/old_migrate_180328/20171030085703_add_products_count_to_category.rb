class AddProductsCountToCategory < ActiveRecord::Migration[5.0]
  def change
    unless column_exists?(:categories, :products_count)
      add_column :categories, :products_count, :integer,
                 null: false, default: 0, comment: '该分类下所有产品的统计'
    end
  end
end
