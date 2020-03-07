require 'rails_helper'

RSpec.describe DpAPI::ApiRequestCredential do
  let(:mock_app) {
    app = double('app')
    allow(app).to receive(:call).and_return([200, {}, []])
    app
  }

  let(:request_credential) { DpAPI::ApiRequestCredential.new(mock_app) }

  let!(:user) { FactoryGirl.create(:user) }

  describe 'validate request' do
    let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

    it "should return code 801 when app_key is empty" do
      env = { 'HTTP_X_DP_APP_KEY' => '',
              'HTTP_X_DP_CLIENT_IP' => 'localhost',
              'REQUEST_URI' => '/login'}
      response = request_credential.call(env)
      expect(response[0]).to eql(801)
    end

    it "should return code 802 when client ip is empty" do
      env = { 'HTTP_X_DP_APP_KEY' => '467109f4b44be6398c17f6c058dfa7eecuowu',
              'HTTP_X_DP_CLIENT_IP' => '',
              'REQUEST_URI' => '/login'}
      response = request_credential.call(env)
      expect(response[0]).to eql(801)
    end

    it "should return code 802 when app_key is not correct" do
      env = { 'HTTP_X_DP_APP_KEY' => '467109f4b44be6398c17f6c058dfa7eecuowu',
              'HTTP_X_DP_CLIENT_IP' => 'localhost',
              'REQUEST_URI' => '/login'}
      response = request_credential.call(env)
      expect(response[0]).to eql(802)
    end

    let(:access_token) do
      AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
    end

    it "should return code 803 when access_token is not correct" do
      env = { 'HTTP_X_DP_APP_KEY' => '467109f4b44be6398c17f6c058dfa7ee',
              'HTTP_X_DP_CLIENT_IP' => 'localhost',
              'HTTP_X_DP_ACCESS_TOKEN' => '123456',
              'REQUEST_URI' => '/login'}
      response = request_credential.call(env)
      expect(response[0]).to eql(804)
    end

    it "should return code 200 when everything is correct" do
      env = { 'HTTP_X_DP_APP_KEY' => '467109f4b44be6398c17f6c058dfa7ee',
              'HTTP_X_DP_CLIENT_IP' => 'localhost',
              'HTTP_X_DP_ACCESS_TOKEN' => access_token,
              'REQUEST_URI' => '/login'}
      response = request_credential.call(env)
      expect(response[0]).to eql(200)
    end
  end
end