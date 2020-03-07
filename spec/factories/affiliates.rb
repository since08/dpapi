FactoryGirl.define do
  factory :affiliate do
    aff_uuid '94bff89e53611ac7fbb3786a03157486'
    aff_name 'DeshPro.com'
    aff_type 'company'
    status 0
  end

  factory :affiliate_app do
    app_id 'dpapi'
    app_name '扑客'
    app_key '467109f4b44be6398c17f6c058dfa7ee'
    app_secret '18ca083547bb164b94a0f89a7959548b'
    status 0
    affiliate
  end
end
