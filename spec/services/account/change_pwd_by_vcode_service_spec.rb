require 'rails_helper'

RSpec.describe Services::Account::ChangePwdByVcodeService do
  let!(:user) { FactoryGirl.create(:user) }

  context "缺少参数" do
    it "should return code 1100001" do
      vcode_service = Services::Account::ChangePwdByVcodeService
      api_result = vcode_service.call('', '13713662278', '2278', user)
      expect(api_result.code).to eq(1100001)
    end
  end

  context "新密码非md5格式" do
    it "should return code 1100015" do
      vcode_service = Services::Account::ChangePwdByVcodeService
      api_result = vcode_service.call('happy', '13713662278', '2278', user)
      expect(api_result.code).to eq(1100015)
    end
  end

  context "验证码不一致" do
    it "should return code 1100018" do
      vcode_service = Services::Account::ChangePwdByVcodeService
      api_result = vcode_service.call('cc03e747a6afbbcbf8be7668acfebee7', '13713662278', '2222', user)
      expect(api_result.code).to eq(1100018)
    end
  end

  context "密码更新成功" do
    let(:v_code) {VCode.generate_mobile_vcode('change_pwd', '13713662278')}
    it "should return code 0" do
      vcode_service = Services::Account::ChangePwdByVcodeService
      api_result = vcode_service.call('cc03e747a6afbbcbf8be7668acfebee7', '13713662278', v_code, user)
      expect(api_result.code).to eq(0)
    end
  end
end