class AddSchedulesToRaceDesc < ActiveRecord::Migration[5.0]
  def change
    add_column :race_descs, :schedules, :text, comment: '赛程信息'
    add_column :race_desc_ens, :schedules, :text, comment: '赛程信息'
  end
end
