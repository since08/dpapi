class CreateProductCounter < ActiveRecord::Migration[5.0]
  def change
    create_table :product_counters do |t|
      t.references :product
      t.integer    :all_page_view, default: 0, comment: '总浏览量'
      t.integer    :sales_volume, default: 0, comment: '销售量'
    end
  end
end
