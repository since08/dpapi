FactoryGirl.define do
  factory :user do
    user_uuid 'uuid_123456789'
    user_name 'Ricky'
    nick_name 'Ricky'
    avatar File.open(Rails.root.join('spec/factories/foo.png'))
    gender 2
    password_salt 'abcdef'
    password ::Digest::MD5.hexdigest('cc03e747a6afbbcbf8be7668acfebee5abcdef') #test123
    mobile '18018001880'
    email 'ricky@deshpro.com'
    reg_date Time.now
    last_visit Time.now
    latitude 26.56667
    longitude 106.71667
  end
end
