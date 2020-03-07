class CreateHotInfo < ActiveRecord::Migration[5.0]
  def change
    create_table :hot_infos do |t|
      t.references :source, polymorphic: true
      t.bigint :position, limit: 20, comment: '用于拖拽排序'
    end
  end
end
