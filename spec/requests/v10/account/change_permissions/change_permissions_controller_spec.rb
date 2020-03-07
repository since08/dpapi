require 'rails_helper'

RSpec.describe "/v10/account/users/:user_id/change_password", :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:create_stat) { FactoryGirl.create(:account_change_stat, user: user2) }

  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end

  let(:access_token2) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user2.user_uuid)
  end
  let(:v_code) {VCode.generate_mobile_vcode('change_pwd', '13713662278')}

  context "未登录情况下访问" do
    it "应当返回 code: 805" do
      params = {
          type:        'email'
      }
      post v10_account_user_change_permission_url(user.user_uuid),
           headers: http_headers,
           params: params
      expect(response).to have_http_status(805)
    end
  end

  context "传入的参数的类型不正确" do
    it "应当返回 code: 1100002" do
      params = {
          type:       'test'
      }
      post v10_account_user_change_permission_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: params
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100002)
    end
  end

  context "正确传入参数，但是没有修改过" do
    it "应当返回 code: 0" do
      params = {
          type:       'mobile'
      }
      post v10_account_user_change_permission_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: params
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(0)
    end
  end

  context "正确传入参数，近期有修改过" do
    it "应当返回 code: 1100056" do
      create_stat
      params = {
          type:       'mobile'
      }
      post v10_account_user_change_permission_url(user2.user_uuid),
           headers: http_headers.merge({ HTTP_X_DP_ACCESS_TOKEN: access_token2 }),
           params: params
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100056)
    end
  end
end