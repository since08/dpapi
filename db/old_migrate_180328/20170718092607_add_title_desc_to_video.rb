class AddTitleDescToVideo < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :title_desc, :string, comment: '视频标题简短描述'
    add_column :video_ens, :title_desc, :string, comment: '视频标题简短描述'
  end
end
