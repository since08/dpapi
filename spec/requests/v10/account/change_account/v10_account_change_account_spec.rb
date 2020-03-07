require 'rails_helper'

RSpec.describe "/v10/account/change_account", :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:user) { FactoryGirl.create(:user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end

  context "传递过来的参数不正确" do
    it "应当返回code 1100002" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "invalid", account: "13833337890", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100002)
    end
  end

  context "传递过来的account或new_code或old_code为空" do
    it "应当返回code 1100001" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "13833337890", new_code: "", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100001)
    end

    it "应当返回code 1100001" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100001)
    end

    it "应当返回code 1100001" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "13833337890", new_code: "123456", old_code: "" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100001)
    end
  end

  context "传入的邮箱或者手机号码格式不正确" do
    it "应当返回code 0" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "12355664433", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100012)
    end

    it "应当返回code 0" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "email", account: "rickyer", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100011)
    end
  end

  context "手机已绑定或者邮箱已绑定" do
    it "应当返回code 1100014" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "email", account: "ricky@deshpro.com", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100014)
    end

    it "应当返回code 1100014" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "18018001880", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100013)
    end
  end

  context "正确传入参数" do
    it "应当返回code 0" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "13833337890", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(0)
      expect(json['data']['user_id']).to eq('uuid_123456789')
      expect(json['data']['nick_name']).to eq('Ricky')
      expect(json['data']['mobile']).to eq('13833337890')
    end

    it "应当返回code 0" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "email", account: "rr@deshpro.com", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(0)
      expect(json['data']['user_id']).to eq('uuid_123456789')
      expect(json['data']['nick_name']).to eq('Ricky')
      expect(json['data']['email']).to eq('rr@deshpro.com')
    end
  end

  context "修改完旧密码后，使用原来的手机号登录应该不存在" do
    it "应该旧手机号找不到用户，并且可以作为绑定的手机号码了" do
      # 模拟登录
      post v10_login_url,
           headers: http_headers,
           params: {type:'mobile', mobile: '18018001880', password: "cc03e747a6afbbcbf8be7668acfebee5"}
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      login_user = json["data"]
      login_access_token = json["data"]["access_token"]

      # 请求更改手机号
      post v10_account_user_change_account_index_url(login_user["user_id"]),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: login_access_token}),
           params: { type: "mobile", account: "13833337890", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json_c = JSON.parse(response.body)
      expect(json_c["code"]).to eq(0)

      # 再次使用原来的手机 应该登录不了了
      post v10_login_url,
           headers: http_headers,
           params: {type:'mobile', mobile: '18018001880', password: "cc03e747a6afbbcbf8be7668acfebee5"}
      expect(response).to have_http_status(200)
      json_login = JSON.parse(response.body)
      expect(json_login["code"]).to eq(1100016)
    end
  end
end
