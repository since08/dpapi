require 'rails_helper'

RSpec.describe "/v10/Uploaders/AvatarController", :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:user) { FactoryGirl.create(:user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end

  let(:image_file) { fixture_file_upload("#{Rails.root}/spec/factories/images/test.png", "image/png") }

  let(:text_file) { fixture_file_upload("#{Rails.root}/README.md", "text/markdown") }

  context "上传头像失败的例子" do
    context "上传参数为空" do
      it "应当返回 code: 1200001" do
        post v10_uploaders_avatar_index_url,
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1200001)
      end
    end

    context "上传一个错误类型的文件" do
      it "应当返回 code: 1200001" do
        post v10_uploaders_avatar_index_url,
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: { avatar: text_file }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1200001)
      end
    end

    context "正常上传一个文件" do
      it "应当返回 code: 0" do
        post v10_uploaders_avatar_index_url,
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: { avatar: image_file }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
      end
    end
  end
end