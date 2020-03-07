require 'rails_helper'

RSpec.describe Services::Account::MobileLoginService do
  let!(:user) { FactoryGirl.create(:user) }

  context "手机号为空" do
    it "should return code 1100001" do
      mobile_service = Services::Account::MobileLoginService
      api_result = mobile_service.call(nil, 1212, '')
      expect(api_result.code).to eq(1100001)
    end
  end

  context "密码为空" do
    it "should return code 1100001" do
      mobile_service = Services::Account::MobileLoginService
      api_result = mobile_service.call('13713662278', nil, '')
      expect(api_result.code).to eq(1100001)
    end
  end

  context "用户不存在" do
    it "should return code 1100016" do
      mobile_service = Services::Account::MobileLoginService
      api_result = mobile_service.call('13622773344', 'cc03e747a6afbbcbf8be7668acfebee5', '')
      expect(api_result.code).to eq(1100016)
    end
  end

  context "密码不正确" do
    it "should return code 1100017" do
      mobile_service = Services::Account::MobileLoginService
      api_result = mobile_service.call('18018001880', 'cc03e747a6afbbcbf8be7668acfebee6', '')
      expect(api_result.code).to eq(1100017)
    end
  end

  context "通过手机号和密码正常登录" do
    it "should return code 1100015" do
      mobile_service = Services::Account::MobileLoginService
      api_result = mobile_service.call('18018001880', 'cc03e747a6afbbcbf8be7668acfebee5', '')
      expect(api_result.code).to eq(0)
    end
  end
end