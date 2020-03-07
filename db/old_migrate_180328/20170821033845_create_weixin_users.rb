class CreateWeixinUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :weixin_users do |t|
      t.references :user
      t.string  :open_id, comment: '用户的open_id'
      t.string  :nick_name, comment: '用户昵称'
      t.integer :sex, comment: '用户性别'
      t.string  :province, comment: '用户所在的省份'
      t.string  :city, comment: '用户所在的城市'
      t.string  :country, comment: '用户所在的省份'
      t.string  :head_img, comment: '用户头像'
      t.string  :privilege, comment: '用户权限列表'
      t.string  :union_id, comment: 'union id'
      t.timestamps
    end
  end
end
