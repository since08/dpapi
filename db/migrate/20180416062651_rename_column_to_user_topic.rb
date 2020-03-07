class RenameColumnToUserTopic < ActiveRecord::Migration[5.0]
  def change
    remove_column :user_topics, :gc_business
    remove_column :user_topics, :location
    add_column :user_topics, :address_title, :string, default: '', comment: '地址标题'
    add_column :user_topics, :address, :string, default: '', comment: '地址详情'
  end
end
