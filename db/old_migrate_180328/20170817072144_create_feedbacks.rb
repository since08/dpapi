class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.references :user, default: 0
      t.string :content, comment: '反馈内容'
      t.string :contact, comment: '联系方式'
      t.boolean :dealt, default: 0, comment: '是否已处理'
    end
  end
end
