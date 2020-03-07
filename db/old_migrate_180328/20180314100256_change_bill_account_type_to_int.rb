class ChangeBillAccountTypeToInt < ActiveRecord::Migration[5.0]
  def change
    change_column :bills, :amount, :decimal, precision: 8, scale: 2, default: 0
  end
end
