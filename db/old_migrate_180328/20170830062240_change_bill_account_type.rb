class ChangeBillAccountType < ActiveRecord::Migration[5.0]
  def up
    change_column :bills, :amount, :integer
  end

  def down
    change_column :bills, :amount, :float
  end
end
