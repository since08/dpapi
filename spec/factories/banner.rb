FactoryGirl.define do
  factory :banner do
    source_type 'link'
    link 'www.baidu.com'
    image File.open(Rails.root.join('spec/factories/foo.png'))
  end
end
