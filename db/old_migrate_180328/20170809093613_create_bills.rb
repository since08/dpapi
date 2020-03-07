class CreateBills < ActiveRecord::Migration[5.0]
  def change
    create_table :bills do |t|
      t.string :merchant_id, comment: '商户号'
      t.string :order_number, limit: 30, comment: '订单号'
      t.float :amount, comment: '支付价格'
      t.string :pay_time, comment: '支付时间'
      t.string :trade_number, comment: '交易商户编号'
      t.string :trade_status, comment: '返回的status'
      t.string :trade_code, comment: '返回的code'
      t.string :trade_msg, comment: '返回的交易状态信息'
      t.timestamps
    end
  end
end
