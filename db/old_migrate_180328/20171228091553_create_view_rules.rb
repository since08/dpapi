class CreateViewRules < ActiveRecord::Migration[5.0]
  def change
    create_table :topic_view_rules do |t|
      t.integer :day, default: 0, comment: '第几天'
      t.integer :interval, default: 0, comment: '时间间隔，单位分钟'
      t.integer :min_increase, default: 0, comment: '最小增长量'
      t.integer :max_increase, default: 0, comment: '最大增长量'
      t.boolean :hot, default: false, comment: '是否是热增长'
      t.timestamps
    end

    create_table :topic_view_toggles do |t|
      t.references :topic, polymorphic: true, comment: '节点资讯或视频'
      t.boolean :toggle_status, default: false, comment: '是否打开, 默认关闭'
      t.boolean :hot, default: false, comment: '是否是热增长'
      t.datetime :begin_time
      t.datetime :last_time
      t.timestamps
    end
  end
end
