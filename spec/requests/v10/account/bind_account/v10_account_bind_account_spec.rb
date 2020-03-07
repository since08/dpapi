require 'rails_helper'

RSpec.describe "/v10/account/bind_account", :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:user) { FactoryGirl.create(:user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end

  context "传递过来的参数不正确" do
    it "应当返回code 1100002" do
      post v10_account_user_bind_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "invalid", account: "13833337890", code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100002)
    end
  end

  context "传递过来的account或code为空" do
    it "应当返回code 1100001" do
      post v10_account_user_bind_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "13833337890", code: "" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100001)
    end

    it "应当返回code 1100001" do
      post v10_account_user_bind_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "", code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100001)
    end

    context "正常传递参数过来" do
      it "it 应当返回code: 0" do
        post v10_account_user_bind_account_index_url(user.user_uuid),
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: { type: "mobile", account: "13714456677", code: "345678" }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
        expect(json["data"]["mobile"]).to eq("13714456677")
      end

      it "it 应当返回code: 0" do
        post v10_account_user_bind_account_index_url(user.user_uuid),
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: { type: "email", account: "rick@deshpro.com", code: "345678" }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
        expect(json["data"]["email"]).to eq("rick@deshpro.com")
      end
    end

    context "邮箱或手机号已绑定" do
      it "it 应当返回code: 1100013" do
        post v10_account_user_bind_account_index_url(user.user_uuid),
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: { type: "mobile", account: "18018001880", code: "345678" }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100013)
      end

      it "it 应当返回code: 1100014" do
        post v10_account_user_bind_account_index_url(user.user_uuid),
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: { type: "email", account: "ricky@deshpro.com", code: "345678" }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100014)
      end
    end
  end
end