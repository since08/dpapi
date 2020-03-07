class AddRecordStatusToOrder < ActiveRecord::Migration[5.0]
  def change
    # 添加用户众筹 比赛状态
    add_column :crowdfunding_orders,
               :record_status,
               :string,
               default: 'unpublished',
               comment: 'unpublished未公布，success晋级成功, failed失败'

    # 更换poker为浮点数类型
    remove_column :poker_coins, :number
    add_column :poker_coins, :number, :decimal, precision: 8, scale: 2, default: 0, comment: '扑客币换成浮点数'

    # 将必要的数据库表换成utf8mb4
    char_set = 'utf8mb4'
    collation = 'utf8mb4_unicode_ci'
    %w(crowdfunding_categories crowdfunding_players players).each do |table_name|
      execute "ALTER TABLE `#{table_name}` CONVERT TO CHARACTER SET #{char_set} COLLATE #{collation};"
    end
  end
end
