class CreateRaceScheduleEn < ActiveRecord::Migration[5.0]
  def change
    create_table :race_schedule_ens do |t|
      t.references :race
      t.string   'schedule', limit: 100, comment: '日程表'
      t.datetime 'begin_time'
      t.timestamps
    end

    RaceSchedule.find_each do |schedule|
      RaceScheduleEn.create(schedule.attributes)
    end
  end
end
