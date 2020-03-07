class ExtendToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :published, :boolean, default: false, comment: '是否上架'
    add_column :products, :recommended, :boolean, default: false, comment: '是否推荐'
  end
end
