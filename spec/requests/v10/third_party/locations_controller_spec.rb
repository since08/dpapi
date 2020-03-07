require 'rails_helper'
require 'request_helper'

RSpec.describe '/v10/third_party/locations', type: :request do
  include RequestHelper

  it '返回当前位置列表(高德地图)' do
    params = {
      latitude: '22.1564360',
      longitude: '113.5562177'
    }
    get v10_third_party_locations_url, params: params, headers: request_header
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
    expect(json['data']['nearbys'].size).to eq(20)
    expect(json['data']['base']['geo_type']).to eq('amap')
  end

  it '返回当前位置列表(谷歌地图)' do
    params = {
      latitude: '22.1564360',
      longitude: '113.5562177',
      geo_type: 'google'
    }
    get v10_third_party_locations_url, params: params, headers: request_header
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
    expect(json['data']['nearbys'].size).to eq(20)
    expect(json['data']['base']['geo_type']).to eq('google')
  end
end
