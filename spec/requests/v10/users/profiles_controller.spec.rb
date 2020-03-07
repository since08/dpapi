require "rails_helper"
require "request_helper"

RSpec.describe '/v10/users/:user_id/profile', type: :request do
  include RequestHelper

  it '返回用户信息' do
    get v10_user_profile_url(user.user_uuid), headers: request_header
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
    expect(json['data']['user_id']).to eq(user.user_uuid)
  end
end
