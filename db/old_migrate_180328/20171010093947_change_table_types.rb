class ChangeTableTypes < ActiveRecord::Migration[5.0]
  def up
    char_set = 'utf8mb4'
    collation = 'utf8mb4_unicode_ci'
    %w(users weixin_users).each do |table_name|
      execute "ALTER TABLE `#{table_name}` CONVERT TO CHARACTER SET #{char_set} COLLATE #{collation};"
    end
  end

  def down
    char_set = 'utf8'
    collation = 'utf8_unicode_ci'
    %w(users weixin_users).each do |table_name|
      execute "ALTER TABLE `#{table_name}` CONVERT TO CHARACTER SET #{char_set} COLLATE #{collation};"
    end
  end
end
