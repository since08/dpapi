require 'rails_helper'

RSpec.describe '/v10/uploaders/tmp_image', type: 'request' do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:user) { FactoryGirl.create(:user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end

  let(:image_file) { fixture_file_upload("#{Rails.root}/spec/factories/images/test.png", "image/png") }
  let(:text_file) { fixture_file_upload("#{Rails.root}/README.md", "text/markdown") }

  context '上传图片' do
    it '当用户未登录时' do
      post v10_uploaders_tmp_image_index_url,
           headers: http_headers


      expect(response).to have_http_status(805)
    end

    it '缺少参数' do
      post v10_uploaders_tmp_image_index_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(1200001)
    end

    it '上传不合法的文件' do
      post v10_uploaders_tmp_image_index_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: { image: text_file }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(1200001)
    end

    it '上传的文件合法' do
      post v10_uploaders_tmp_image_index_url,
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: { image: image_file }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['code']).to eq(0)
    end
  end
end