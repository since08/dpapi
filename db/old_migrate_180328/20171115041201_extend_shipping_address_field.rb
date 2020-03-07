class ExtendShippingAddressField < ActiveRecord::Migration[5.0]
  def change
    add_column :shipping_addresses, :province, :string, default: '', comment: '省份'
    add_column :shipping_addresses, :city, :string, default: '', comment: '城市'
    add_column :shipping_addresses, :area, :string, default: '', comment: '区域'
  end
end
