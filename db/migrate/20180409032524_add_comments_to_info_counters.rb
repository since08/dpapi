class AddCommentsToInfoCounters < ActiveRecord::Migration[5.0]
  def change
    add_column :info_counters, :comments, :integer, default: 0, comment: '资讯的评论数'
    add_column :video_counters, :comments, :integer, default: 0, comment: '视频的评论数'
    add_column :user_topic_counters, :view_increment, :integer, default: 0, comment: '浏览量增量'
  end
end
