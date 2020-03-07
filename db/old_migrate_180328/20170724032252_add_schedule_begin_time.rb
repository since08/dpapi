class AddScheduleBeginTime < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :schedule_begin_time, :string, comment: '赛程开始时间'
    add_column :race_ens, :schedule_begin_time, :string, comment: '赛程开始时间'
  end
end
