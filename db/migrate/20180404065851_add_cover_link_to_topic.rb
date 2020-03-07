class AddCoverLinkToTopic < ActiveRecord::Migration[5.0]
  def change
    add_column :user_topics, :cover_link, :string, default: '', comment: '长帖需要的封面链接'
  end
end
