class ChangeCommentTableType < ActiveRecord::Migration[5.0]
  def change
    char_set = 'utf8mb4'
    collation = 'utf8mb4_unicode_ci'
    %w(comments replies).each do |table_name|
      execute "ALTER TABLE `#{table_name}` CONVERT TO CHARACTER SET #{char_set} COLLATE #{collation};"
    end
  end
end
