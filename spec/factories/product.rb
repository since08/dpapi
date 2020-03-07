FactoryGirl.define do
  factory :product do
    association :category
    association :freight
    sequence(:title) { |n| "产品_#{n}" }
    published  true
    freight_free  true
    icon File.open(Rails.root.join('spec/factories/foo.png'))

    after(:create) do |product|
      create(:variant, product: product, is_master: true)
    end
  end

  factory :variant do
    price 1.01
    original_price 88
    stock 88
    volume 88
    weight 88
    origin_point '深圳'
  end

  factory :category do
    name '分类名'
  end

end
