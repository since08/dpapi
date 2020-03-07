class AddSomeFieldToUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :recommended
    add_column :comments, :recommended, :boolean, default: false, comment: '是否精选'
    remove_column :comments, :deleted
    add_column :comments, :deleted, :boolean, default: false, comment: '是否删除'
    remove_column :replies, :deleted
    add_column :replies, :deleted, :boolean, default: false, comment: '是否删除'
    add_column :users, :tag, :string, default: '', comment: '评论管理给用户贴的标签'
    add_column :users, :silenced, :boolean, default: false, comment: '是否被禁言'
    add_column :users, :silence_at, :datetime, comment: '被禁言的时间'
    add_column :users, :silence_till, :datetime, comment: '解禁的时间'
    add_column :users, :silence_reason, :string, default: '', comment: '被禁言的原因'
    add_column :users, :blocked, :boolean, default: false, comment: '是否被拉入黑名单'
    add_column :users, :blocked_at, :datetime, comment: '被拉入黑名单时间'
  end
end
