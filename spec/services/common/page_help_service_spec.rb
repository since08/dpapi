require 'rails_helper'

RSpec.describe Services::Common::PageHelpService do
  let!(:race) { FactoryGirl.create(:race) }

  context "分页相关" do
    it "should return json data" do
      params = {
          page_index: 1,
          page_size: 10
      }
      page_help_service = Services::Common::PageHelpService
      api_result = page_help_service.proc_page_result(20, params)
      expect(api_result[:page_index]).to eq(1)
      expect(api_result[:page_size]).to eq(10)
      expect(api_result[:page_count]).to eq(2)
      expect(api_result[:total_records]).to eq(20)
    end
  end

  context "分页相关" do
    it "should return json data" do
      params = {
          page_index: 1,
          page_size: 10
      }
      page_help_service = Services::Common::PageHelpService
      api_result = page_help_service.proc_page_params(params)
      expect(api_result[:page_index]).to eq(1)
      expect(api_result[:page_size]).to eq(10)
      expect(api_result[:offset]).to eq(0)
    end
  end
end