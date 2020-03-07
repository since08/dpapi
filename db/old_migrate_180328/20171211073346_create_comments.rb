class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :user
      t.references :topic, polymorphic: true, comment: '评论的节点资讯或视频'
      t.text :body, comment: '评论内容'
      t.boolean :recommended, comment: '是否精选'
      t.boolean :deleted
      t.datetime :deleted_at
      t.string :deleted_reason
      t.timestamps
    end

    create_table :replies do |t|
      t.references :user
      t.references :comment, comment: '相关联的评论'
      t.text :body
      t.boolean :deleted
      t.datetime :deleted_at
      t.string :deleted_reason
      t.timestamps
    end

    create_table :info_counters do |t|
      t.integer :page_views, default: 0, comment: '浏览量'
      t.integer :view_increment, default: 0, comment: '浏览量增量'
      t.integer :likes, default: 0, comment: '点赞数'
    end

    create_table :video_counters do |t|
      t.integer :page_views, default: 0, comment: '浏览量'
      t.integer :view_increment, default: 0, comment: '浏览量增量'
      t.integer :likes, default: 0, comment: '点赞数'
    end
  end
end
