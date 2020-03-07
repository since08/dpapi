require 'rails_helper'

RSpec.describe Services::Account::EmailRegisterService do
  let!(:user) { FactoryGirl.create(:user) }

  context "邮箱格式不正确" do
    it "should return code 1100011" do
      email_register_service = Services::Account::EmailRegisterService
      api_result = email_register_service.call({ email: 'phper@lala',
                                                 password: 'cc03e747a6afbbcbf8be7668acfebee6' }, '127.0.0.1')
      expect(api_result.code).to eq(1100011)
    end
  end

  context "邮箱已经存在" do
    it "should return code 1100014" do
      email_register_service = Services::Account::EmailRegisterService
      api_result = email_register_service.call({ email: 'ricky@deshpro.com',
                                                 password: 'cc03e747a6afbbcbf8be7668acfebee6' }, '127.0.0.1')
      expect(api_result.code).to eq(1100014)
    end
  end

  context "密码格式不正确" do
    it "should return code 1100015" do
      email_register_service = Services::Account::EmailRegisterService
      api_result = email_register_service.call({ email: 'ricky@qq.com',
                                                 password: 'test' }, '127.0.0.1')
      expect(api_result.code).to eq(1100015)
    end
  end

  context "邮箱密码格式都正确，创建一个新的用户" do
    it "should return code 0" do
      email_register_service = Services::Account::EmailRegisterService
      api_result = email_register_service.call({ email: 'ricky@qq.com',
                                                 password: 'cc03e747a6afbbcbf8be7668acfebee6' }, '127.0.0.1')
      expect(api_result.code).to eq(0)
    end
  end
end