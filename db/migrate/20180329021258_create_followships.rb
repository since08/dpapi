class CreateFollowships < ActiveRecord::Migration[5.0]
  def change
    create_table :followships do |t|
      t.integer :follower_id, null: false, comment: '粉丝'
      t.integer :following_id, null: false, comment: '关注'

      t.timestamps
    end

    add_column :user_counters, :follower_count, :integer, default: 0, comment: '粉丝数'
    add_column :user_counters, :following_count, :integer, default: 0, comment: '关注数'
  end
end
