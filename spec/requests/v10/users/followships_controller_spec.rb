require 'rails_helper'
require 'request_helper'

RSpec.describe "/v10/users/:user_id/followships", :type => :request do
  include RequestHelper

  let(:user2) { FactoryGirl.create(:user, { user_uuid: 'test123', user_name: 'Geek', mobile: '13655667766', email: 'test2@deshpro.com' }) }
  let(:follow_user) { FactoryGirl.create(:followship, {follower_id: user2.id, following_id: user.id}) }
  let(:follow_user2) { FactoryGirl.create(:followship, {follower_id: user.id, following_id: user2.id}) }
  
  it '返回关注user_uuid列表' do
    follow_user2
    get following_ids_v10_user_followships_url(user.user_uuid), headers: request_header
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['data']['following_ids']).to eq([user2.user_uuid])
  end

  it '返回关注列表' do
    follow_user2
    get followings_v10_user_followships_url(user.user_uuid), headers: request_header
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
    expect(json['data']['followings'].size).to eq(1)
  end

  it '返回粉丝列表' do
    follow_user.update(is_following: true)
    follow_user2.update(is_following: true)
    get followers_v10_user_followships_url(user.user_uuid), headers: request_header
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
    expect(json['data']['followers'].size).to eq(1)
    # 相互关注
    expect(json['data']['followers'][0]['is_following']).to eq(true)
  end

  it '添加关注' do
    post v10_user_followships_url(user.user_uuid), params: {target_id: user2.user_uuid}, headers: request_header
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
  end

  it '取消关注' do
    follow_user2
    delete v10_user_followships_url(user.user_uuid), params: {target_id: user2.user_uuid}, headers: request_header
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
  end

end
