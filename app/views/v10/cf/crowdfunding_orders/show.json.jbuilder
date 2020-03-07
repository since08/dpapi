# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.order_info do
    json.partial! 'order_info', order: @order
  end

  json.crowdfunding_player do
    json.partial! 'v10/cf/players/short_info', cf_player: @order.crowdfunding_player
  end

  json.race do
    json.partial! 'v10/cf/crowdfundings/race_info', race: @order.crowdfunding.race
  end

  json.crowdfunding do
    json.partial! 'v10/cf/crowdfundings/crowdfunding', crowdfunding: @order.crowdfunding
  end

  if @order.user_extra.present?
    json.user_extra do
      json.partial! 'v10/account/users/user_extra_item', user_extra: @order.user_extra
    end
  end
end
