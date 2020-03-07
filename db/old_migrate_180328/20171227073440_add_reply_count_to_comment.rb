class AddReplyCountToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :reply_count, :integer, default: 0, comment: '统计下面有多少个回复'
    add_comment_count
  end

  private

  def add_comment_count
    Comment.unscoped.all.each do |comment|
      count = comment.replies.count
      comment.update(reply_count: count)
    end
  end
end
