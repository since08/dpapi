class AddPositionToRaceBlind < ActiveRecord::Migration[5.0]
  def change
    add_column :race_blinds, :position, :bigint, limit: 20, default: 0, comment: '用于拖拽排序'
  end
end
