class CreateExpressCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :express_codes do |t|
      t.string :name, comment: '快递公司名称'
      t.string :express_code, comment: '快递编码'
      t.string :region, comment: '快递区域: 国外foreign, 国内china，transfer转运'
    end
  end
end
