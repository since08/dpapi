class UpdateReplyTableMoreTypes < ActiveRecord::Migration[5.0]
  def change
    remove_reference :replies, :comment
    add_reference :replies, :typeable, polymorphic: true, comment: '判断回复的父级是评论还是回复'
  end
end
