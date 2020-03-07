class ChangeTableAccountType < ActiveRecord::Migration[5.0]
  def up
    char_set = 'utf8mb4'
    collation = 'utf8mb4_unicode_ci'
    execute "ALTER TABLE `account_change_stats` CONVERT TO CHARACTER SET #{char_set} COLLATE #{collation};"
  end

  def down
    char_set = 'utf8'
    collation = 'utf8_unicode_ci'
    execute "ALTER TABLE `account_change_stats` CONVERT TO CHARACTER SET #{char_set} COLLATE #{collation};"
  end
end
