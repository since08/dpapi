class RemovePublishFromUserTopics < ActiveRecord::Migration[5.0]
  def change
    remove_column :user_topics, :published
    remove_column :user_topics, :published_time
  end
end
