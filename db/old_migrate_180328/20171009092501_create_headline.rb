class CreateHeadline < ActiveRecord::Migration[5.0]
  def change
    create_table :headlines do |t|
      t.references :source, polymorphic: true
      t.string :title, comment: '头条标题'
      t.bigint :position, limit: 20, comment: '用于拖拽排序'
      t.boolean :published, default: false, comment: '是否发布'
    end
  end
end
