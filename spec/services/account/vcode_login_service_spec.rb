require 'rails_helper'

RSpec.describe Services::Account::VcodeLoginService do
  let!(:user) { FactoryGirl.create(:user) }

  context "手机号为空" do
    it "should return code 1100001" do
      vcode_service = Services::Account::VcodeLoginService
      api_result = vcode_service.call(nil, 1212, '')
      expect(api_result.code).to eq(1100001)
    end
  end

  context "验证码为空" do
    it "should return code 1100001" do
      vcode_service = Services::Account::VcodeLoginService
      api_result = vcode_service.call('13713662278', nil, '')
      expect(api_result.code).to eq(1100001)
    end
  end

  context "用户不存在" do
    it "should return code 1100016" do
      vcode_service = Services::Account::VcodeLoginService
      api_result = vcode_service.call('13622773344', '3344', '')
      expect(api_result.code).to eq(1100016)
    end
  end

  context "验证码不正确" do
    it "should return code 1100018" do
      vcode_service = Services::Account::VcodeLoginService
      api_result = vcode_service.call('18018001880', '1882', '')
      expect(api_result.code).to eq(1100018)
    end
  end

  context "通过手机号和验证码正常登录" do
    let(:v_code) {VCode.generate_mobile_vcode('login', '18018001880')}
    it "should return code 0" do
      vcode_service = Services::Account::VcodeLoginService
      api_result = vcode_service.call('18018001880', v_code, '')
      expect(api_result.code).to eq(0)
    end
  end
end