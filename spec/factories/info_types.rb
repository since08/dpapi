FactoryGirl.define do
  factory :info_type do
    sequence(:name) { |n| "新闻_#{n}" }
    published  true
    level 0

    # 一个栏目下创建多条资讯
    factory :info_type_with_info do
      after(:create) do |info_type|
        # 创建1条非置顶的
        create(:info, info_type: info_type)

        #创建一条置顶的
        top_info = create(:info, info_type: info_type)
        top_info.top!
      end
    end
  end
end
