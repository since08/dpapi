FactoryGirl.define do
  factory :race do
    sequence(:name) { |n| "2017APT启航站第#{n}场" }
    logo File.open(Rails.root.join('spec/factories/foo.png'))
    sequence(:prize) { |n| "100_000_#{n}" }
    sequence(:location) { |n| "澳门_#{n}" }
    sequence(:seq_id) { |n| n }
    ticket_price 10_000
    sequence(:begin_date) { Random.rand(1..9).days.since.strftime('%Y-%m-%d') }
    sequence(:end_date)   { Random.rand(11..19).days.since.strftime('%Y-%m-%d') }
  end
end
