class AddUpdatesToAppVersion < ActiveRecord::Migration[5.0]
  def change
    add_column :app_versions, :title, :string, comment: '更新标题'
    add_column :app_versions, :content, :string, comment: '更新内容'
  end
end
