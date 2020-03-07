# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.refund_number refund.refund_number
  json.refund_type  refund&.product_refund_type&.name
  json.refund_price refund.refund_price
  json.refund_poker_coins refund.refund_poker_coins
  json.memo refund.memo.to_s
  json.admin_memo refund.admin_memo.to_s
  json.status refund.status
  json.created_at refund.created_at.to_i
  if refund&.product_refund_images.present?
    json.images do
      json.array! refund.product_refund_images do |image|
        json.image_url image&.image_path.to_s
        json.memo image.memo.to_s
      end
    end
  end
  json.refund_order_items do
    json.array! refund.product_refund_details do |refund_item|
      json.partial! 'v10/shop_order/product_orders/order_item', item: refund_item.product_order_item
    end
  end
end