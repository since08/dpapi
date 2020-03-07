# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.invite_code do
    json.name          @code.name
    json.coupon_type   @code.coupon_type
    json.coupon_number @code.coupon_number
  end
end

