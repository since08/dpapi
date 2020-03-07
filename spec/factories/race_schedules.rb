FactoryGirl.define do
  factory :race_schedule do
    schedule '2A'
    begin_time Time.current

    association :race
  end
end
