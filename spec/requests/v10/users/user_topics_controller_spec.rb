require 'rails_helper'
require 'request_helper'

RSpec.describe '/v10/users/:user_id/user_topics/my_focus' do
  include RequestHelper
  it 'return the list of topics that I focus on' do
    get my_focus_v10_user_user_topics_url(user.user_uuid), headers: request_header
    expect(response).to have_http_status(200)
    body = JSON.parse(response.body)
    expect(body['code']).to eq(0)
  end
end
