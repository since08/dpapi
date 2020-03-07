require 'rails_helper'

RSpec.describe Services::UniqueNumberGenerator do
  let(:e_ticket_params) do
    {
      ticket_type: 'e_ticket',
      email: 'test@gmail.com',
      cert_id: user_extra.id
    }
  end
  let!(:race) { FactoryGirl.create(:race) }
  let!(:ticket) { FactoryGirl.create(:ticket, race: race, status: 'selling') }
  let!(:ticket_info) { FactoryGirl.create(:ticket_info, ticket: ticket) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_extra) { FactoryGirl.create(:user_extra, user: user, status: 'passed') }
  let(:generate_order) do
    Services::Orders::CreateOrderService.call(race, ticket, user, e_ticket_params)
  end
  let(:purchase_order_prefix) do
    Services::UniqueNumberGenerator::MODE_PREFIX_MAP[:PurchaseOrder]
  end

  context '当今天还未产生过编号时' do
    it '返回的编号应为 model映射的前缀 + 今天当前时间 + 00001' do
      number = Services::UniqueNumberGenerator.call(PurchaseOrder)
      today_first_number = "#{purchase_order_prefix}#{Time.current.strftime('%y%m%d%H%M')}00001"
      expect(number).to eq(today_first_number)
    end
  end

  context '当今天产生过编号时' do
    it '返回的编号应顺着上个编号 +1' do
      number = Services::UniqueNumberGenerator.call(PurchaseOrder)
      today_first_number = "#{purchase_order_prefix}#{Time.current.strftime('%y%m%d%H%M')}00001"

      expect(number).to eq(today_first_number)

      number = Services::UniqueNumberGenerator.call(PurchaseOrder)
      today_second_number = "#{purchase_order_prefix}#{Time.current.strftime('%y%m%d%H%M')}00002"
      expect(number).to eq(today_second_number)
    end
  end

  context '当今天生成过编号，但redis缓存被清除了' do
    it '返回的编号应接着最后一个编号加1' do
      result = generate_order
      expect(result.code).to   eq(0)

      Rails.cache.clear
      number = Services::UniqueNumberGenerator.call(PurchaseOrder)
      today_second_number = "#{purchase_order_prefix}#{Time.current.strftime('%y%m%d%H%M')}00002"
      expect(number).to eq(today_second_number)
    end
  end

  context '数据库有之前编号记录，今天未生成编号' do
    it '返回的编号应为今天日期 + 00001' do
      result = generate_order
      expect(result.code).to   eq(0)
      order = result.data[:order]
      order.update(order_number: '2017010100003')

      Rails.cache.clear
      number = Services::UniqueNumberGenerator.call(PurchaseOrder)
      today_first_number = "#{purchase_order_prefix}#{Time.current.strftime('%y%m%d%H%M')}00001"
      expect(number).to eq(today_first_number)
    end
  end
end