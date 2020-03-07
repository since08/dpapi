require 'rails_helper'

RSpec.describe '/v10/races/:race_id/ticket/:ticket_id/orders', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }

  let!(:race) { FactoryGirl.create(:race) }
  let!(:ticket) { FactoryGirl.create(:ticket, race: race, status: 'selling') }
  let!(:ticket_info) { FactoryGirl.create(:ticket_info, ticket: ticket) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_extra) { FactoryGirl.create(:user_extra, user: user, status: 'passed') }
  let(:shipping_address) { FactoryGirl.create(:shipping_address, user: user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end
  let(:e_ticket_params) do
    {
        ticket_type: 'e_ticket',
        email: 'test@gmail.com',
        cert_id: user_extra.id
    }
  end
  let(:entity_ticket_params) do
    {
      ticket_type: 'entity_ticket',
      mobile: '13428725222',
      consignee: '收货人先生',
      address: '收货地址',
      cert_id: user_extra.id
    }
  end

  context '购票成功' do
    it '成功购票返回 order_number' do
      race_id = race.id
      post v10_race_ticket_orders_url(race_id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)
      expect(json['data']['order_number'].blank?).to be_falsey
    end

    it '成功购买电子票' do
      race_id = race.id
      post v10_race_ticket_orders_url(race_id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order = user.orders.find_by(ticket_id: ticket.id)
      expect(order).to be_truthy
      expect(order.status).to  eq('unpaid')
      expect(order.ticket_type).to  eq('e_ticket')
    end

    it '成功购买实体票' do
      race_id = race.id
      post v10_race_ticket_orders_url(race_id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: entity_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order = user.orders.find_by(ticket_id: ticket.id)
      expect(order).to be_truthy
      expect(order.status).to  eq('unpaid')
      expect(order.ticket_type).to  eq('entity_ticket')
    end

    it '兼容老版本：成功购买实体票' do
      race_id = race.id
      params = entity_ticket_params.dup
      params[:cert_id] = nil
      post v10_race_ticket_orders_url(race_id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order = user.orders.find_by(ticket_id: ticket.id)
      expect(order).to be_truthy
      expect(order.status).to  eq('unpaid')
      expect(order.ticket_type).to  eq('entity_ticket')
    end

    # it '购买电子票:当用户实名状态为init，应改成 pending' do
    #   user_extra.update(status: 'init')
    #   post v10_race_ticket_orders_url(race.id, ticket.id),
    #        headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
    #        params: e_ticket_params
    #
    #   expect(response).to have_http_status(200)
    #   json = JSON.parse(response.body)
    #   expect(json['code']).to   eq(0)
    #
    #   user_extra.reload
    #   expect(user_extra.status).to eq('pending')
    # end
    #
    # it '购买实体票:当用户实名状态为init，应改成 pending' do
    #   user_extra.update(status: 'init')
    #   post v10_race_ticket_orders_url(race.id, ticket.id),
    #        headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
    #        params: entity_ticket_params
    #
    #   expect(response).to have_http_status(200)
    #   json = JSON.parse(response.body)
    #   expect(json['code']).to   eq(0)
    #
    #   user_extra.reload
    #   expect(user_extra.status).to eq('pending')
    # end

    it '购买电子票应创建snapshot' do
      race_id = race.id
      post v10_race_ticket_orders_url(race_id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order = user.orders.find_by(race_id: race_id)
      expect(order.snapshot).to be_truthy
    end

    it '购买实体票应创建snapshot' do
      race_id = race.id
      post v10_race_ticket_orders_url(race_id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: entity_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order = user.orders.find_by(race_id: race_id)
      expect(order.snapshot).to be_truthy
    end

    it '购买成功电子票电子票已售票数应加1' do
      old_sold_num = ticket_info.e_ticket_sold_number
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      ticket_info.reload
      expect(ticket_info.e_ticket_sold_number - old_sold_num).to   eq(1)
    end

    it '购买成功实体票，已售票数应加1' do
      old_sold_num = ticket_info.entity_ticket_sold_number
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: entity_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      ticket_info.reload
      expect(ticket_info.entity_ticket_sold_number - old_sold_num).to   eq(1)
    end

    it '当实体票与电子票都售完，应改变状态为 sold_out, 由电子票触发' do
      ticket_info.update(e_ticket_sold_number: 49, entity_ticket_sold_number: 50)
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      ticket.reload
      expect(ticket.status).to eq('sold_out')
    end

    it '当实体票与电子票都售完，应改变状态为 sold_out, 由实体票触发' do
      ticket_info.update(entity_ticket_sold_number: 49, e_ticket_sold_number: 50)
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: entity_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      ticket.reload
      expect(ticket.status).to eq('sold_out')
    end

    it '取消票成功，可以继续购电子票' do
      result = Services::Orders::CreateOrderService.call(race, ticket, user, e_ticket_params)
      expect(result.code).to   eq(0)

      order = user.orders.find_by_race_id(race.id)
      result = Services::Orders::CancelOrderService.call(order, user)
      expect(result.code).to   eq(0)

      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)
    end

    it '取消票成功，可以继续购实体票' do
      result = Services::Orders::CreateOrderService.call(race, ticket, user, entity_ticket_params)
      expect(result.code).to   eq(0)

      order = user.orders.find_by_race_id(race.id)
      result = Services::Orders::CancelOrderService.call(order, user)
      expect(result.code).to   eq(0)

      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: entity_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)
    end

    it '邀请码无折扣的情况' do
      race_id = race.id
      invite_code = InviteCode.create(name: '上级人')
      post v10_race_ticket_orders_url(race_id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params.merge(invite_code: invite_code.code)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order = user.orders.find_by(ticket_id: ticket.id)
      expect(order).to be_truthy
      expect(order.invite_code).to eq(invite_code.code)
      expect(order.price).to eq(ticket.price)
    end

    it '邀请码为95折的情况' do
      race_id = race.id
      invite_code = InviteCode.create(name: '上级人', coupon_type: 'rebate', coupon_number: 95)
      post v10_race_ticket_orders_url(race_id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params.merge(invite_code: invite_code.code)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order = user.orders.find_by(ticket_id: ticket.id)
      expect(order).to be_truthy
      expect(order.invite_code).to eq(invite_code.code)
      expect(order.price).to eq(ticket.price * 0.95)
    end

    it '邀请码为减少1000的情况' do
      race_id = race.id
      invite_code = InviteCode.create(name: '上级人', coupon_type: 'reduce', coupon_number: 1000)
      post v10_race_ticket_orders_url(race_id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params.merge(invite_code: invite_code.code)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order = user.orders.find_by(ticket_id: ticket.id)
      expect(order).to be_truthy
      expect(order.invite_code).to eq(invite_code.code)
      expect(order.price).to eq(ticket.price - 1000)
    end
  end

  context '购票失败' do
    ##
    # 放开限购一张的限制
    # it '限购一张，重复购票' do
    #   result = Services::Orders::CreateOrderService.call(race, ticket, user, e_ticket_params)
    #   expect(result.code).to   eq(0)
    #
    #   post v10_race_ticket_orders_url(race.id, ticket.id),
    #        headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
    #        params: e_ticket_params
    #
    #   expect(response).to have_http_status(200)
    #   json = JSON.parse(response.body)
    #   expect(json['code']).to   eq(1100039)
    # end

    it '用户传的实名信息id不存在时' do
      user.user_extra.destroy
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100006)
    end

    it '售票状态不为selling' do
      ticket.update(status: 'end')
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100038)
    end

    it '未开启售票功能' do
      race.update(ticket_sellable: false)
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100033)
    end

    it '购买电子票，电子票已票完' do
      ticket_info.update(e_ticket_sold_number: 50)
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100040)
    end

    it '购买实体票，实体票已票完' do
      ticket_info.update(entity_ticket_sold_number: 50)
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: entity_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100037)
    end

    it '购买电子票，email错误' do
      post v10_race_ticket_orders_url(race.id, ticket.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params.merge(email: '1212')

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100004)
    end
  end

end