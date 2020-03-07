class AddTagToActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :tag, :string, comment: '活动标签'
  end
end
