require 'rails_helper'

RSpec.describe Services::Account::ChangePwdByPwdService do
  let!(:user) { FactoryGirl.create(:user) }

  context "密码为空" do
    it "should return code 1100001" do
      vcode_service = Services::Account::ChangePwdByPwdService
      api_result = vcode_service.call('', 'cc03e747a6afbbcbf8be7668acfebee5', user)
      expect(api_result.code).to eq(1100001)
    end
  end

  context "新密码不是md5的" do
    it "should return code 1100015" do
      vcode_service = Services::Account::ChangePwdByPwdService
      api_result = vcode_service.call('invalid', 'cc03e747a6afbbcbf8be7668acfebee5', user)
      expect(api_result.code).to eq(1100015)
    end
  end

  context "输入的密码和之前存在的不一致" do
    it "should return code 1100017" do
      vcode_service = Services::Account::ChangePwdByPwdService
      api_result = vcode_service.call('cc03e747a6afbbcbf8be7668acfebee6', 'cc03e747a6afbbcbf8be7668acfebee7', user)
      expect(api_result.code).to eq(1100017)
    end
  end

  context "密码更新成功" do
    it "should return code 0" do
      vcode_service = Services::Account::ChangePwdByPwdService
      api_result = vcode_service.call('cc03e747a6afbbcbf8be7668acfebee6', 'cc03e747a6afbbcbf8be7668acfebee5', user)
      expect(api_result.code).to eq(0)
    end
  end
end