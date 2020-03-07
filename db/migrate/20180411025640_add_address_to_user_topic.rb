class AddAddressToUserTopic < ActiveRecord::Migration[5.0]
  def change
    add_column :user_topics, :gc_business, :string, default: '', comment: '位置关键词'
  end
end
