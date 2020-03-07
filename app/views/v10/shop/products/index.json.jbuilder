# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.products do
    json.partial! 'v10/shop/products/products', products: @products
  end
end