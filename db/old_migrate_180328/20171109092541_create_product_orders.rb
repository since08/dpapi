class CreateProductOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :product_orders do |t|
      t.references :user
      t.string   :order_number, limit: 32, null: false, comment: '商品订单编号'
      t.string   :name, limit: 32, comment: '订单名称'
      t.string   :status, default: 'unpaid', comment: '订单状态'
      t.string   :pay_status, default: 'unpaid', comment: '支付状态'
      t.string   :shipping_status, default: 'unshipped', comment: '发货状态'
      t.decimal  :shipping_price, default: 0, precision: 5, scale: 2, comment: '总运费'
      t.decimal  :total_product_price, default: 0, precision: 8, scale: 2, comment: '总商品费用'
      t.decimal  :total_price, default: 0, precision: 8, scale: 2, comment: '支付费用，包含订单商品和运费'
      t.datetime :cancelled_at, comment: '取消时间'
      t.string   :cancel_reason, default: '', comment: '取消原因'
      t.timestamps
    end

    create_table   :product_order_items do |t|
      t.references :product_order
      t.references :variant
      t.decimal    :original_price, null: false, precision: 8, scale: 2, comment: '原始价格'
      t.decimal    :price, null: false, precision: 8, scale: 2, comment: '实际价格'
      t.integer    :number, null: false, comment: '购买数量'
      t.string     :sku_value, default: '', comment: '商品属性组合'
      t.string     :shipping_status, default: 'unshipped', comment: '发货状态'
      t.timestamps
    end

    create_table :product_shipments do |t|
      t.references :product_order
      t.references :express_code
      t.string :shipping_company, comment: '快递公司'
      t.string :shipping_number, comment: '快递单号'
      t.timestamps
    end

    create_table :product_shipment_with_order_items do |t|
      t.references :product_shipment
      t.references :product_order_item
      t.timestamps
    end

    create_table :product_shipping_addresses do |t|
      t.references :product_order
      t.string :name, comment: '收货人姓名'
      t.string :province
      t.string :city
      t.string :area
      t.string :address
      t.string :mobile
      t.string :zip
      t.string :change_reason, comment: '后台修改地址的原因'
      t.string :memo, comment: '修改备注'
      t.timestamps
    end

    create_table :product_wx_bills do |t|
      t.references :product_order
      t.string :bank_type, comment: '付款银行'
      t.integer :cash_fee, comment: '现金支付金额'
      t.string :fee_type, comment: '货币类型'
      t.string :is_subscribe, comment: '是否关注'
      t.string :mch_id, comment: '商户ID'
      t.string :open_id, comment: '支付用户的openid'
      t.string :time_end, comment: '订单支付时间'
      t.integer :total_fee, comment: '订单总金额'
      t.string :trade_type, comment: '交易类型'
      t.string :transaction_id, comment: '微信支付的流水号'
      t.string :result_code
      t.string :return_code
      t.timestamps
    end
  end
end
