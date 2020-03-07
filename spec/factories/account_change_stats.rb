FactoryGirl.define do
  factory :account_change_stat do
    user
    change_time Time.current
    account_type "mobile"
  end
end
