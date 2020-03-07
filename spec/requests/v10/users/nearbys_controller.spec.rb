require 'rails_helper'
require 'request_helper'

RSpec.describe '/v10/users/:user_id/nearbys' do
  include RequestHelper

  it 'return nearbys user' do
    get v10_user_nearbys_url(user.user_uuid), headers: request_header
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
  end

  it 'update the location of user' do
    old_latitude, old_longitude = user.latitude, user.longitude
    post v10_user_nearbys_url(user.user_uuid), params: { longitude: 115.90000, latitude: 28.68333 }, headers: request_header
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
    new_user = user.reload
    expect(old_latitude).not_to eq(new_user.latitude)
    expect(old_longitude).not_to eq(new_user.longitude)
  end
end
