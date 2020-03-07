json.shipping_address do
  json.id             shipping_address.id
  json.consignee      shipping_address.consignee
  json.mobile         shipping_address.mobile
  json.address_detail shipping_address.address_detail
  json.address        shipping_address.address
  json.post_code      shipping_address.post_code
end

