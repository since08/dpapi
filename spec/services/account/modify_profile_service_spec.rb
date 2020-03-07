require 'rails_helper'

RSpec.describe Services::Account::ModifyProfileService do
  let!(:user) { FactoryGirl.create(:user) }

  context "用户信息更改成功" do
    it "should return code 1100012" do
      mobile_register_service = Services::Account::ModifyProfileService
      user_modified = mobile_register_service.call(user, { nick_name: 'ruby',
                                                           gender: 2,
                                                           birthday: '20150303',
                                                           signature: '浪人' })
      expect(user_modified.nick_name).to eq('ruby')
      expect(user_modified.gender).to eq(2)
      expect(user_modified.birthday.to_s).to eq("2015-03-03")
      expect(user_modified.signature).to eq('浪人')
    end
  end
end