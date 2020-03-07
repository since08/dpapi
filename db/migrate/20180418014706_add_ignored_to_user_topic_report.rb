class AddIgnoredToUserTopicReport < ActiveRecord::Migration[5.0]
  def change
    add_column :user_topic_reports, :ignored, :boolean, default: false, comment: '是否忽略'
    add_index  :user_topic_reports, :ignored
  end
end
