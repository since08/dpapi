class AddReplyToUserToReplies < ActiveRecord::Migration[5.0]
  def change
    add_column :replies, :reply_user_id, :integer, comment: '回复对应的那个人id'
    add_index :replies, :reply_user_id
    create_default_data
  end

  private

  def create_default_data
    Reply.unscoped.all.each do |reply|
      # 优先判断它是否属于某个回复
      if reply.reply.present?
        reply.update(reply_user_id: reply.reply.user.id)
      else
        reply.update(reply_user_id: reply.comment.user.id)
      end
    end
  end
end
