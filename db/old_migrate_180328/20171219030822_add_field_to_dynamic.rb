class AddFieldToDynamic < ActiveRecord::Migration[5.0]
  def change
    add_column :dynamics,
               :option_type,
               :string,
               default: 'normal',
               comment: 'normal,普通评论或回复，delete后台删除'
    add_index :dynamics, :option_type
  end
end
