FactoryGirl.define do
  factory :tmp_image do
    image File.open(Rails.root.join('spec/factories/foo.png'))
  end
end
