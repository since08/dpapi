class CreateProductRefunds < ActiveRecord::Migration[5.0]
  def change
    create_table :tmp_images do |t|
      t.string :image, comment: '用户上传的临时图片'
      t.timestamps
    end

    create_table :product_refund_types do |t|
      t.string :name
      t.timestamps
    end

    create_table :product_refunds do |t|
      t.references :product_order_item
      t.references :product_refund_type
      t.string :refund_number, limit: 32, null: false, comment: '商品退款编号'
      t.decimal :refund_price, null: false, precision: 8, scale: 2, comment: '退款金额'
      t.string :memo, comment: '申请退换原因'
      t.string :admin_memo, comment: '审核结果原因'
      t.string :status, default: 'open', comment: '退换货状态open审核中, close关闭或审核不通过, completed审核通过完成'
      t.timestamps
    end

    create_table :product_refund_images do |t|
      t.references :product_refund
      t.string :image, comment: '用户退款的图片'
      t.string :memo, comment: '图片说明'
      t.timestamps
    end
  end
end
