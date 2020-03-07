require 'rails_helper'

RSpec.describe Services::Races::RaceRecentService do
  let!(:race) { FactoryGirl.create(:race) }

  context "传入的参数没有number字段" do
    it "should return code 0" do
      race_recent_service = Services::Races::RaceRecentService
      api_result = race_recent_service.call(0, nil)
      expect(api_result.code).to eq(0)
    end
  end

  context "传入的参数有number字段 但是字段格式不正确" do
    it "should return code 1100004" do
      race_recent_service = Services::Races::RaceRecentService
      api_result = race_recent_service.call(0, 'abc')
      expect(api_result.code).to eq(1100004)
    end
  end
end