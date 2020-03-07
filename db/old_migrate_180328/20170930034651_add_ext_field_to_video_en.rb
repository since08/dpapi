class AddExtFieldToVideoEn < ActiveRecord::Migration[5.0]
  def change
    add_reference :video_ens, :video_group
    add_column :video_ens, :is_main, :boolean, default: false, comment: '是否是主视频'
    add_column :video_ens, :level, :integer, default: 0, comment: '用于自定义排序'
  end
end
