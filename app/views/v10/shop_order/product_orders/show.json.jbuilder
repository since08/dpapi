# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.partial! 'v10/shop_order/product_orders/order_info', order: @order
  json.order_items do
    json.array! @order.product_order_items do |item|
      json.partial! 'v10/shop_order/product_orders/order_item', item: item
    end
  end
  json.address do
    json.partial! 'v10/shop_order/product_orders/address', order: @order
  end
  if @order.delivered
    json.shipments do
      json.partial! 'v10/shop_order/product_orders/shipment', order: @order
    end
  end
end