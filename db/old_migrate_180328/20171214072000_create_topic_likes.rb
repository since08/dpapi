class CreateTopicLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :topic_likes do |t|
      t.references :user
      t.references :topic, polymorphic: true, comment: '点赞的节点资讯或视频'
      t.boolean :canceled, default: false, comment: '是否取消点赞'
      t.timestamps
    end
  end
end
