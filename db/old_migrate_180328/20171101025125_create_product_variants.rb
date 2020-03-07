class CreateProductVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :option_types do |t|
      t.references :product
      t.string    :name
      t.integer   :position,     default: 0, null: false
      t.timestamps
    end

    create_table :option_values do |t|
      t.references :option_type
      t.string     :name
      t.integer    :position, default: 0
      t.timestamps
    end

    create_table :variants do |t|
      t.references :product
      t.string     :sku,                default: '', null: false, comment: 'sku'
      t.string     :sku_option_values,  default: '', null: false, comment: '该sku(单品)所有选项值的json数据'
      t.decimal    :price,              precision: 8, scale: 2, default: 0, comment: '实付金额'
      t.decimal    :original_price,     precision: 8, scale: 2, default: 0
      t.decimal    :weight,             precision: 8, scale: 3, comment: '商品重量，计量单位为kg'
      t.decimal    :volume,             precision: 8, scale: 2, comment: '商品体积，计量单位为m3'
      t.integer    :stock,              default: 0, comment: '库存'
      t.string     :origin_point,       comment: '发货地点'
      t.boolean    :is_master,          default: false, comment: 'true 为商品的默认variant的属性'
      t.datetime   :deleted_at
      t.timestamps
    end

    create_table :variant_option_values do |t|
      t.references :variant
      t.references :option_value
      t.references :option_type
    end
  end
end
