FactoryGirl.define do
  factory :user_extra do
    association       :user
    real_name         '王石'
    cert_type         'chinese_id'
    cert_no           '611002199301146811'
    memo              '身份证'
    status            'pending'
    image             File.open(Rails.root.join('spec/factories/foo.png'))
  end
end