require 'rails_helper'

RSpec.describe "/v10/login (SessionsController)", :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }



  let(:mobile_params) do
    {
        type:   'others',
        mobile: '18866668888',
        vcode:  '8888'
    }
  end

  let!(:user) { FactoryGirl.create(:user) }
  let(:v_code) {VCode.generate_mobile_vcode('login', '18018001880')}

  context "无效登录 传递不合法的登录类型" do
    it "应当返回 code: 1100002 (UNSUPPORTED_TYPE)" do
      post v10_login_url,
           headers: http_headers,
           params: mobile_params
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100002)
    end
  end

  context "手机+验证码登录" do
    context "手机号为空" do
      it "应当返回 code: 1100001" do
        post v10_login_url,
             headers: http_headers,
             params: {type:'vcode', vcode: '12345'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100001)
      end
    end

    context "验证码为空" do
      it "应当返回 code: 1100001" do
        post v10_login_url,
             headers: http_headers,
             params: {type:'vcode', mobile: '18866668888'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100001)
      end
    end

    context "手机号对应的用户不存在" do
      it "应当返回 code: 1100016" do
        post v10_login_url,
             headers: http_headers,
             params: {type:'vcode', mobile: '18866668888', vcode: "1110"}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100016)
      end
    end

    context "验证码不正确" do
      it "应当返回 code: 1100018" do
        post v10_login_url,
             headers: http_headers,
             params: {type:'vcode', mobile: '18018001880', vcode: "1110"}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100018)
      end
    end

    context "手机号正常登录" do
      it "应当返回 code: 0" do
        post v10_login_url,
             headers: http_headers,
             params: {type:'vcode', mobile: '18018001880', vcode: v_code}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
        expect(json["data"]["user_id"]).to eq("uuid_123456789")
        expect(json["data"]["nick_name"]).to eq("Ricky")
        expect(json["data"]["gender"]).to eq(2)
        expect(json["data"]["mobile"]).to eq("18018001880")
        expect(json["data"]["email"]).to eq("ricky@deshpro.com")
        expect(json["data"]["avatar"].nil?).to be_falsey
        expect(json["data"]["reg_date"]).to be_truthy
        expect(json["data"]["last_visit"]).to be_truthy
        expect(json["data"]["signature"].nil?).to be_falsey

        expect(get(json["data"]["avatar"])).to eq(200)
      end
    end

    context "邮箱+密码登录" do
      context "邮箱为空" do
        it "应当返回 code: 1100001" do
          post v10_login_url,
               headers: http_headers,
               params: {type:'email', email: '', password: "cc03e747a6afbbcbf8be7668acfebee5"}
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json["code"]).to eq(1100001)
        end
      end

      context "密码为空" do
        it "应当返回 code: 1100001" do
          post v10_login_url,
               headers: http_headers,
               params: {type:'email', email: 'ricky@deshpro.com', password: ""}
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json["code"]).to eq(1100001)
        end
      end

      context "邮箱对应的用户不存在" do
        it "应当返回 code: 1100016" do
          post v10_login_url,
               headers: http_headers,
               params: {type:'email', email: 'ruby@deshpro.com', password: "cc03e747a6afbbcbf8be7668acfebee5"}
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json["code"]).to eq(1100016)
        end
      end

      context "密码不正确" do
        it "应当返回 code: 1100017" do
          post v10_login_url,
               headers: http_headers,
               params: {type:'email', email: 'ricky@deshpro.com', password: "cc03e747a6afbbcbf8be7668acfebee6"}
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json["code"]).to eq(1100017)
        end
      end

      context "邮箱正常登录" do
        it "应当返回 code: 0" do
          post v10_login_url,
               headers: http_headers,
               params: {type:'email', email: 'ricky@deshpro.com', password: "cc03e747a6afbbcbf8be7668acfebee5"}
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json["code"]).to eq(0)
          expect(json["data"]["user_id"]).to eq("uuid_123456789")
          expect(json["data"]["nick_name"]).to eq("Ricky")
          expect(json["data"]["gender"]).to eq(2)
          expect(json["data"]["mobile"]).to eq("18018001880")
          expect(json["data"]["email"]).to eq("ricky@deshpro.com")
          expect(json["data"]["avatar"].nil?).to be_falsey
          expect(json["data"]["reg_date"]).to be_truthy
          expect(json["data"]["last_visit"]).to be_truthy
          expect(json["data"]["signature"].nil?).to be_falsey

          expect(get(json["data"]["avatar"])).to eq(200)
        end
      end

      context "手机号+密码登录" do
        context "手机号为空" do
          it "应当返回 code: 1100001" do
            post v10_login_url,
                 headers: http_headers,
                 params: {type:'mobile', mobile: '', password: "cc03e747a6afbbcbf8be7668acfebee5"}
            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["code"]).to eq(1100001)
          end
        end

        context "密码为空" do
          it "应当返回 code: 1100001" do
            post v10_login_url,
                 headers: http_headers,
                 params: {type:'mobile', mobile: '18866668888', password: ""}
            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["code"]).to eq(1100001)
          end
        end

        context "密码不正确" do
          it "应当返回 code: 1100017" do
            post v10_login_url,
                 headers: http_headers,
                 params: {type:'mobile', mobile: '18018001880', password: "cc03e747a6afbbcbf8be7668acfebee6"}
            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["code"]).to eq(1100017)
          end
        end

        context "手机号正常登录" do
          it "应当返回 code: 0" do
            post v10_login_url,
                 headers: http_headers,
                 params: {type:'mobile', mobile: '18018001880', password: "cc03e747a6afbbcbf8be7668acfebee5"}
            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["code"]).to eq(0)
            expect(json["data"]["user_id"]).to eq("uuid_123456789")
            expect(json["data"]["nick_name"]).to eq("Ricky")
            expect(json["data"]["gender"]).to eq(2)
            expect(json["data"]["mobile"]).to eq("18018001880")
            expect(json["data"]["email"]).to eq("ricky@deshpro.com")
            expect(json["data"]["avatar"].nil?).to be_falsey
            expect(json["data"]["reg_date"]).to be_truthy
            expect(json["data"]["last_visit"]).to be_truthy
            expect(json["data"]["signature"].nil?).to be_falsey
            expect(get(json["data"]["avatar"])).to eq(200)
          end
        end
      end
    end
  end
end