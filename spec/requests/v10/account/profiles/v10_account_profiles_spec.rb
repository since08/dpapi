require 'rails_helper'

RSpec.describe "/v10/uploaders/avatar (ProfilesController)", :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }


  let!(:user) { FactoryGirl.create(:user) }

  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end

  context "查询用户个人信息，当传入不正常的uuid" do
    it "应当返回 code: 805(HTTP_LOGIN_REQUIRED)" do
      get v10_account_user_profile_url('none-uuid'),
           headers: http_headers
      expect(response).to have_http_status(805)
    end
  end

  context "查询用户个人信息，当不传access_token" do
    it "应当返回 code: 805(HTTP_LOGIN_REQUIRED)" do
      get v10_account_user_profile_url(user.user_uuid),
          headers: http_headers
      expect(response).to have_http_status(805)
    end
  end

  context "查询用户个人信息，当传不正确的access_token" do
    it "应当返回 code: 804(HTTP_TOKEN_EXPIRED)" do
      get v10_account_user_profile_url(user.user_uuid),
          headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: 'abcdefg'})
      expect(response).to have_http_status(804)
    end
  end

  context "查询用户个人信息，传入正确的uuid 和 正确的access_token" do
    it "应当返回 code: 200" do
      get v10_account_user_profile_url(user.user_uuid),
          headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
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

  context "修改用户个人信息 传入正确的uuid 和 正确的access_token" do
    it "应当返回 code: 200" do
      params = {
        nick_name:     'geek',
        gender:        '1',
        birthday:      '20161212',
        signature:     'haha'
      }
      put v10_account_user_profile_url(user.user_uuid),
          headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
          params: params
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(0)
      expect(json["data"]["user_id"]).to eq("uuid_123456789")
      expect(json["data"]["nick_name"]).to eq("geek")
      expect(json["data"]["gender"]).to eq(1)
      expect(json["data"]["mobile"]).to eq("18018001880")
      expect(json["data"]["email"]).to eq("ricky@deshpro.com")
      expect(json["data"]["avatar"].nil?).to be_falsey
      expect(json["data"]["reg_date"]).to be_truthy
      expect(json["data"]["last_visit"]).to be_truthy
      expect(json["data"]["birthday"]).to eq("2016-12-12")
      expect(json["data"]["signature"]).to eq("haha")
      expect(get(json["data"]["avatar"])).to eq(200)
    end
  end
end