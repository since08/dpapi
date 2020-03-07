class AddIndexToFollowships < ActiveRecord::Migration[5.0]
  def change
    add_column :followships, :is_following, :boolean, default: false, comment: '是否相互关注'
    add_index :followships, [:following_id, :follower_id], unique: true
  end
end
