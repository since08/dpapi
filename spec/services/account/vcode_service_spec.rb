require 'rails_helper'

RSpec.describe Services::Account::VcodeServices do
  let!(:user) { FactoryGirl.create(:user) }

  context "如果请求没有账户id" do
    it "should return code 1100001" do
      vcode_service = Services::Account::VcodeServices
      params = {
          option_type: 'reset_pwd',
          vcode_type: 'email'
      }
      api_result = vcode_service.call(nil, params)
      expect(api_result.code).to eq(1100001)
    end
  end

  context "请求类型为手机注册, 用户存在" do
      it "should return code 1100023" do
        vcode_service = Services::Account::VcodeServices
        params = {
          option_type: 'register',
          vcode_type: 'mobile',
          mobile: '18018001880'
        }
        api_result = vcode_service.call(nil, params)
        expect(api_result.code).to eq(1100023)
      end
  end

  context "请求类型为邮箱注册, 用户存在" do
    it "should return code 1100023" do
      vcode_service = Services::Account::VcodeServices
      params = {
          option_type: 'register',
          vcode_type: 'email',
          email: 'ricky@deshpro.com'
      }
      api_result = vcode_service.call(nil, params)
      expect(api_result.code).to eq(1100023)
    end
  end

  context "请求类型为手机登陆, 用户不存在" do
    it "should return code 1100016" do
      vcode_service = Services::Account::VcodeServices
      params = {
          option_type: 'login',
          vcode_type: 'mobile',
          mobile: '13566778899'
      }
      api_result = vcode_service.call(nil, params)
      expect(api_result.code).to eq(1100016)
    end
  end

  context "请求类型为邮箱登陆, 用户不存在" do
    it "should return code 1100016" do
      vcode_service = Services::Account::VcodeServices
      params = {
          option_type: 'login',
          vcode_type: 'email',
          email: 'ricky@deshpr.com'
      }
      api_result = vcode_service.call(nil, params)
      expect(api_result.code).to eq(1100016)
    end
  end

  context "请求类型为手机注册, 且用户不存在" do
    context "如果手机格式不正确" do
      it "should return code 1100012" do
        vcode_service = Services::Account::VcodeServices
        params = {
            option_type: 'register',
            vcode_type: 'mobile',
            mobile: '12255664455'
        }
        api_result = vcode_service.call(nil, params)
        expect(api_result.code).to eq(1100012)
      end
    end

    context "如果手机格式正确" do
      it "should return code 0" do
        vcode_service = Services::Account::VcodeServices
        params = {
            option_type: 'register',
            vcode_type: 'mobile',
            mobile: '13255664455'
        }
        api_result = vcode_service.call(nil, params)
        expect(api_result.code).to eq(0)
      end
    end
  end

  context "请求类型为邮箱注册, 且用户不存在" do
    context "如果邮箱格式不正确" do
      it "should return code 1100011" do
        vcode_service = Services::Account::VcodeServices
        params = {
            option_type: 'register',
            vcode_type: 'email',
            email: 'ricky@qq'
        }
        api_result = vcode_service.call(nil, params)
        expect(api_result.code).to eq(1100011)
      end
    end

    context "如果手机格式正确" do
      it "should return code 0" do
        vcode_service = Services::Account::VcodeServices
        params = {
            option_type: 'register',
            vcode_type: 'email',
            email: 'ricky@qq.com'
        }
        api_result = vcode_service.call(nil, params)
        expect(api_result.code).to eq(0)
      end
    end
  end
end