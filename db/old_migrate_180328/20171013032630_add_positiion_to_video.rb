class AddPositiionToVideo < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :position, :bigint, limit: 20, default: 0, comment: '用于拖拽排序'
    add_column :video_ens, :position, :bigint, limit: 20, default: 0, comment: '用于拖拽排序'
  end
end
