class ReportTypeUserTopicReport < ActiveRecord::Migration[5.0]
  def change
    add_column :user_topic_reports, :description, :string, default: '', comment: '描述，如私信记录'
    add_column :user_topic_reports, :report_type, :string, default: '', comment: '举报的类型'
    add_index  :user_topic_reports, :report_type
  end
end
