class CreateTopicNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :topic_notifications do |t|
      t.references :user
      t.integer :from_user_id, comment: '来源的用户'
      t.string :notify_type, comment: '消息的类型:评论，回复，点赞...'
      t.string :source_type, comment: '产生消息的出处'
      t.integer :source_id,  comment: '产生消息的出处'
      t.boolean :read, default: false, comment: '是否已读'
      t.timestamps
    end

    add_index :topic_notifications, [:notify_type, :read]
    add_index :topic_notifications, [:source_type, :source_id]
  end
end
