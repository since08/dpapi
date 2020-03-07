require 'rails_helper'

RSpec.describe Race, type: :model do
  context '应使用默认scope' do
    it '创建race时，published应默认true' do
      race = Race.new
      expect(race.published).to be_truthy
    end

    it '获取赛事时，应使用默认scope' do
      FactoryGirl.create(:race)
      FactoryGirl.create(:race, published: 0)
      races = Race.all
      expect(races.size).to eq(1)
    end
  end
end
