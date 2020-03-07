FactoryGirl.define do
  factory :race_host do
    sequence(:name) { |n| "主办方_#{n}" }
  end
end
