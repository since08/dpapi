json.array! race_schedules do |race_schedule|
  json.schedule_id race_schedule.id
  json.schedule race_schedule.schedule.to_s
  json.begin_time race_schedule.begin_time
end
