class CreateBanner < ActiveRecord::Migration[5.0]
  def change
    create_table :banners do |t|
      t.string :image
      t.references :source, polymorphic: true
      t.string :link, comment: '链接地址'
      t.bigint :position, limit: 20, comment: '用于拖拽排序'
      t.boolean 'published', default: false, comment: '是否发布'
    end
  end
end
