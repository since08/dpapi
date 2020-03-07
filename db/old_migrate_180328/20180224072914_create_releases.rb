class CreateReleases < ActiveRecord::Migration[5.0]
  def change
    create_table :releases do |t|
      t.string :keywords, comment: '发布模块关键字'
      t.boolean :published, default: false, comment: '是否发布'
      t.timestamps
    end
  end
end
