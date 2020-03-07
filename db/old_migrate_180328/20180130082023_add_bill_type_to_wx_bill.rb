class AddBillTypeToWxBill < ActiveRecord::Migration[5.0]
  def change
    add_column :wx_bills, :bill_type, :string,
               default: 'ticket',
               comment: 'ticket 票务的账单, crowdfunding 众筹的账单'
  end
end
