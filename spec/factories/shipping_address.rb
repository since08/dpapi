FactoryGirl.define do
  factory :shipping_address do
    association :user
    sequence(:consignee) { |n| "收货人_#{n}" }
    sequence(:mobile) { |n| "1342872522#{n}" }
    sequence(:address_detail) { |n| "中国广东省深圳市收货地址_#{n}" }
    sequence(:post_code) { |n| "22522#{n}" }
  end
end