class AddExtFieldToVideo < ActiveRecord::Migration[5.0]
  def change
    add_reference :videos, :video_group
    add_column :videos, :is_main, :boolean, default: false, comment: '是否是主视频'
    add_column :videos, :level, :integer, default: 0, comment: '用于自定义排序'
  end
end
