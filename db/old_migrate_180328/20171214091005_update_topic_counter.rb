class UpdateTopicCounter < ActiveRecord::Migration[5.0]
  def change
    add_reference :info_counters, :info
    add_reference :video_counters, :video
  end
end
