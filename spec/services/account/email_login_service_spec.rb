require 'rails_helper'

RSpec.describe Services::Account::EmailLoginService do
  let!(:user) { FactoryGirl.create(:user) }

  context "邮箱为空" do
    it "should return code 1100001" do
      email_service = Services::Account::EmailLoginService
      api_result = email_service.call(nil, 1212, '')
      expect(api_result.code).to eq(1100001)
    end
  end

  context "密码为空" do
    it "should return code 1100001" do
      email_service = Services::Account::EmailLoginService
      api_result = email_service.call('ricky@deshpro.com', nil, '')
      expect(api_result.code).to eq(1100001)
    end
  end

  context "用户不存在" do
    it "should return code 1100016" do
      email_service = Services::Account::EmailLoginService
      api_result = email_service.call('ricky@qq.com', 'cc03e747a6afbbcbf8be7668acfebee5', '')
      expect(api_result.code).to eq(1100016)
    end
  end

  context "密码不正确" do
    it "should return code 1100015" do
      email_service = Services::Account::EmailLoginService
      api_result = email_service.call('ricky@deshpro.com', 'cc03e747a6afbbcbf8be7668acfebee6', '')
      expect(api_result.code).to eq(1100017)
    end
  end

  context "通过邮箱和密码正常登录" do
    it "should return code 1100015" do
      email_service = Services::Account::EmailLoginService
      api_result = email_service.call('ricky@deshpro.com', 'cc03e747a6afbbcbf8be7668acfebee5', '')
      expect(api_result.code).to eq(0)
    end
  end
end