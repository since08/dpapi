require 'rails_helper'

RSpec.describe '/v10/activities', type: :request do

  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:create_activities) do
    FactoryGirl.create(:activity)
    FactoryGirl.create(:activity, title: 'pushed_activity', pushed: true, start_push: Time.now, end_push: 1.days.since)
    FactoryGirl.create(:activity)
  end



  context '获取活动列表' do
    it '数据不存在，列表为空' do
      get v10_activities_url, headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['activities'].class).to eq(Array)
    end

    it '列表有相应的数据' do
      create_activities
      get v10_activities_url, headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['activities'].class).to eq(Array)
      expect(json['data']['activities'].size).to eq(3)
    end
  end

  context '获取活动详情' do
    it '存在该活动' do
      activity = create_activities
      get v10_activity_url(activity.id), headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
    end
  end

  context '获取推送到首页的活动' do
    it '存在，返回相应的数据' do
      create_activities
      get pushed_v10_activities_url, headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['activity']['title']).to eq('pushed_activity')
    end

    it '不存在，返回找不到指定记录' do
      get pushed_v10_activities_url, headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100006)
    end
  end
end