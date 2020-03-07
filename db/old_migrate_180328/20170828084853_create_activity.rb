class CreateActivity < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :title, comment: '活动标题'
      t.string :link, comment: 'h5链接'
      t.text :description, comment: '活动描述'
      t.string :banner, comment: '横图'
      t.boolean :pushed, default: false, comment: '推送到首页的图片'
      t.string :pushed_img, comment: '推送到首页的图片'
      t.datetime :activity_time, comment: '活动时间'
    end
  end
end
