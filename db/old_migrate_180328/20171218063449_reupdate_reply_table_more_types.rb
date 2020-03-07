class ReupdateReplyTableMoreTypes < ActiveRecord::Migration[5.0]
  def change
    remove_reference :replies, :typeable, polymorphic: true
    add_reference :replies, :comment, comment: '追溯回复的哪条评论'
    add_reference :replies, :reply, comment: '追溯回复的是哪条回复'
  end
end
