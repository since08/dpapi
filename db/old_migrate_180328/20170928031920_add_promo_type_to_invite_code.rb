class AddPromoTypeToInviteCode < ActiveRecord::Migration[5.0]
  def change
    add_column :invite_codes, :coupon_type, :string,
               default: 'no_discount',
               comment: '邀请码优惠类型， rebate是打折，reduce是减价格, 默认是none，没有优惠'
    add_column :invite_codes, :coupon_number, :integer,
               default: 0,
               comment: '邀请码折扣数量， 打折的话是数字大小0..100, 减价0..商品价格'
  end
end
