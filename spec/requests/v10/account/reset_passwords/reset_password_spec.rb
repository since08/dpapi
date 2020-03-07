require 'rails_helper'

RSpec.describe "/v10/uploaders/avatar (ProfilesController)", :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }


  let!(:user) { FactoryGirl.create(:user) }
  let(:v_code) {VCode.generate_mobile_vcode('reset_pwd', '18018001880')}

  context "传入不正确的重置类型" do
    it "should return code 1100021" do
      post v10_account_reset_password_url,
          headers: http_headers,
           params: { type: 'haha' }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100021)
    end
  end

  context "手机号的方式找回密码" do
     context "传入的手机号为空" do
       it "should return code 1100001" do
         post v10_account_reset_password_url,
              headers: http_headers,
              params: { type: 'mobile', mobile: '', vcode: '2278', password: 'cc03e747a6afbbcbf8be7668acfebee5' }
         expect(response).to have_http_status(200)
         json = JSON.parse(response.body)
         expect(json["code"]).to eq(1100001)
       end
     end

    context "传入的密码不符合要求" do
      it "should return code 1100015" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'mobile', mobile: '13713662278', vcode: '2278', password: 'test' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100015)
      end
    end

    context "验证码错误" do
      it "should return code 1100018" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'mobile', mobile: '13713662278', vcode: '2272', password: 'cc03e747a6afbbcbf8be7668acfebee5' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100018)
      end
    end

    context "用户不存在" do
      it "should return code 1100018" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'mobile', mobile: '13713662299', vcode: '2278', password: 'cc03e747a6afbbcbf8be7668acfebee5' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100018)
      end
    end

    context "重置成功" do
      it "should return code 0" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'mobile', mobile: '18018001880', vcode: v_code, password: 'cc03e747a6afbbcbf8be7668acfebee5' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
      end
    end
  end

  context "邮箱的方式找回密码" do
    context "验证码为空" do
      it "should return code 1100001" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'email', email: 'ricky@deshpro.com', vcode: '', password: 'cc03e747a6afbbcbf8be7668acfebee5' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100001)
      end
    end

    context "邮箱为空" do
      it "should return code 1100001" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'email', email: '', vcode: 'abcd', password: 'cc03e747a6afbbcbf8be7668acfebee5' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100001)
      end
    end

    context "密码为空" do
      it "should return code 1100001" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'email', email: 'ricky@deshpro.com', vcode: 'abcd', password: '' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100001)
      end
    end

    context "密码不符合规则" do
      it "should return code 1100015" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'email', email: 'ricky@deshpro.com', vcode: 'abcd', password: 'test' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100015)
      end
    end

    context "验证码不正确" do
      it "should return code 1100018" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'email', email: 'ricky@deshpro.com', vcode: 'cd', password: 'cc03e747a6afbbcbf8be7668acfebee5' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100018)
      end
    end

    context "用户不存在" do
      let!(:v_code) {VCode.generate_email_vcode('reset_pwd', 'ricky@qq.com')}
      it "should return code 1100016" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'email', email: 'ricky@qq.com', vcode: v_code, password: 'cc03e747a6afbbcbf8be7668acfebee5' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100016)
      end
    end

    context "重置密码成功" do
      let!(:v_code) {VCode.generate_email_vcode('reset_pwd', 'ricky@deshpro.com')}
      it "should return code 0" do
        post v10_account_reset_password_url,
             headers: http_headers,
             params: { type: 'email', email: 'ricky@deshpro.com', vcode: v_code, password: 'cc03e747a6afbbcbf8be7668acfebee5' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
      end
    end
  end
end