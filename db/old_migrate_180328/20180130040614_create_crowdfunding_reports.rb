class CreateCrowdfundingReports < ActiveRecord::Migration[5.0]
  def change
    create_table :crowdfunding_reports do |t|
      t.references :crowdfunding
      t.references :crowdfunding_player
      t.datetime :record_time, comment: '赛事的记录时间'
      t.string :title, default: '', comment: '赛事标题'
      t.integer :level, default: 0, comment: '赛事级别'
      t.string :small_blind, default: '0', comment: '最小盲注'
      t.string :big_blind, default: '0', comment: '最大盲注'
      t.string :ante, default: '0', comment: '前注'
      t.text :description, limit: 65535, comment: '图文内容'
      t.timestamps
    end
  end
end
