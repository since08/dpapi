class SetReportTableUtf8bin4 < ActiveRecord::Migration[5.0]
  def change
    char_set = 'utf8mb4'
    collation = 'utf8mb4_unicode_ci'
    %w(crowdfunding_reports).each do |table_name|
      execute "ALTER TABLE `#{table_name}` CONVERT TO CHARACTER SET #{char_set} COLLATE #{collation};"
    end
  end
end
