class SyncShippingAddressData < ActiveRecord::Migration[5.0]
  def up
    ShippingAddress.all.each do |item|
      next unless item.address
      item.province = item.address.split(' ').first
      item.city = item.address.split(' ').second
      item.area = item.address.split(' ').third
      item.save!
    end
  end

  def down
    ShippingAddress.all.each do |item|
      item.update(province: '', city: '', area: '')
    end
  end
end
