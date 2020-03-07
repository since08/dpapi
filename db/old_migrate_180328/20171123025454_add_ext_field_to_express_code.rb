class AddExtFieldToExpressCode < ActiveRecord::Migration[5.0]
  def change
    add_column :express_codes, :phone, :string, default: '', comment: '官方电话'
    add_column :express_codes, :site, :string, default: '', comment: '官网地址'
  end
end
