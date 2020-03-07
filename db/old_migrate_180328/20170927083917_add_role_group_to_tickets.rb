class AddRoleGroupToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :role_group, :string,
               default: 'everyone',
               comment: 'everyone 所有人 tester测试人员'
    add_column :ticket_ens, :role_group, :string,
               default: 'everyone',
               comment: 'everyone 所有人 tester测试人员'
  end
end
