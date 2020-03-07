class CreateUserTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :user_topics, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.references :user
      t.string :title, default: '', comment: '长帖的标题'
      t.text :body, comment: '说说或长帖的内容'
      t.string :body_type, default: 'short', comment: '说说或长帖'
      t.boolean :recommended, default: false, comment: '是否精选'
      t.boolean :published, default: false, comment: 'false为草稿(默认)，true为发布'
      t.datetime :published_time, comment: '发布时间'
      t.boolean :abnormal, default: false, comment: '是否异常'
      t.boolean :deleted, default: false, comment: '标记后台是否删除'
      t.datetime :deleted_at
      t.string :deleted_reason, default: '', comment: '管理员删除的原因'
      t.float :lat, comment: '经度'
      t.float :lng, comment: '纬度'
      t.string :location, default: '', comment: '发帖的地理位置'
      t.timestamps
    end

    create_table :user_topic_images do |t|
      t.references :user_topic
      t.string :image
      t.timestamps
    end

    create_table :user_topic_counters do |t|
      t.references :user_topic
      t.integer :page_views, default: 0, comment: '浏览量'
      t.integer :likes, default: 0, comment: '点赞数'
      t.integer :comments, default: 0, comment: '评论数'
      t.integer :reports, default: 0, comment: '被举报数'
      t.timestamps
    end

    create_table :user_topic_reports, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.references :user
      t.references :user_topic
      t.integer :report_user_id, comment: '举报人id'
      t.string :body, comment: '举报的内容'
      t.timestamps
    end

    create_table :report_templates do |t|
      t.string :name
      t.timestamps
    end
  end
end
