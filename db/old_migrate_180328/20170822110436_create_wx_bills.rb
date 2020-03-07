class CreateWxBills < ActiveRecord::Migration[5.0]
  def change
    create_table :wx_bills do |t|
      t.string :appid, comment: '授权公众号appid'
      t.string :bank_type, comment: '付款银行'
      t.integer :cash_fee, comment: '现金支付金额'
      t.string :fee_type, comment: '货币类型'
      t.string :is_subscribe, comment: '是否关注'
      t.string :mch_id, comment: '商户ID'
      t.string :open_id, comment: '支付用户的openid'
      t.string :out_trade_no, comment: '商户订单'
      t.string :result_code
      t.string :return_code
      t.string :time_end, comment: '订单支付时间'
      t.integer :total_fee, comment: '订单总金额'
      t.string :trade_type, comment: '交易类型'
      t.string :transaction_id, comment: '微信支付的流水号'
      t.timestamps
    end
  end
end
