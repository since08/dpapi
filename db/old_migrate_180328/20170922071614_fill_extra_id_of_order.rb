class FillExtraIdOfOrder < ActiveRecord::Migration[5.0]
  def change
    PurchaseOrder.find_each do |order|
      order.user_extra = order.user.user_extra
      order.save
    end
  end
end
