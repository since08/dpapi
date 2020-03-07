class AddIsReadToReplies < ActiveRecord::Migration[5.0]
  def change
    add_column :replies, :is_read, :boolean, default: false, comment: '标记回复是否已读'
    add_index :replies, :is_read
  end
end
