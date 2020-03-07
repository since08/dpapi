require 'rails_helper'

RSpec.describe '/v10/feedbacks', type: :request do

  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:user) { FactoryGirl.create(:user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end


  context '创建意见反馈' do
    it '缺少参数，创建失败' do
      post v10_feedbacks_url, headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100001)
    end

    it '创建成功' do
      post v10_feedbacks_url, headers: http_headers,
           params: {content: '测试内容', contact: 12121}
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      post v10_feedbacks_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: {content: '测试内容', contact: 12121}
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
    end
  end
end