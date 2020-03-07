class CreateActivityEn < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :start_push, :datetime, comment: '推送开始时间'
    add_column :activities, :end_push, :datetime, comment: '推送结束时间'
    add_column :activities, :push_type, :string,
               default: 'once_a_day',
               comment: '推送类型 每日一次 once_a_day， 仅一次 once'

    create_table :activity_ens do |t|
      t.string :title, comment: '活动标题'
      t.string :link, comment: 'h5链接'
      t.string :tag, comment: '活动标签'
      t.text :description, comment: '活动描述'
      t.string :banner, comment: '横图'
      t.boolean :pushed, default: false, comment: '推送到首页的图片'
      t.string :pushed_img, comment: '推送到首页的图片'
      t.string :push_type, default: 'once_a_day', comment: '推送类型 每日一次 once_a_day， 仅一次 once'
      t.datetime :activity_time, comment: '活动时间'
      t.datetime :start_push, comment: '推送开始时间'
      t.datetime :end_push, comment: '推送结束时间'
      t.timestamps
    end
  end
end
