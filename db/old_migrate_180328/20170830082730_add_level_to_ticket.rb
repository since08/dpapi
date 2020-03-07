class AddLevelToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :level, :integer, default: 0, comment: '用于自定义排序'
    add_column :ticket_ens, :level, :integer, default: 0, comment: '用于自定义排序'
  end
end
