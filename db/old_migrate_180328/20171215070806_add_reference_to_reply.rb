class AddReferenceToReply < ActiveRecord::Migration[5.0]
  def change
    add_reference :replies, :topic, polymorphic: true, comment: '评论的节点资讯或视频'
  end
end
