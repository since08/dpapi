# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
desh = Affiliate.where(aff_uuid: '94bff89e53611ac7fbb3786a03157486').first
if desh.nil?
  desh = Affiliate.new
  desh.aff_uuid = '94bff89e53611ac7fbb3786a03157486'
  desh.aff_name = '深圳市德尚全彩体育文化有限公司'
  desh.aff_type = 'company'
  desh.status = 0
  desh.save
end

unless AffiliateApp.exists?(app_key: '467109f4b44be6398c17f6c058dfa7ee')
  apps = AffiliateApp.new
  apps.affiliate = desh
  apps.app_id = 'dpapi'
  apps.app_name = '深圳市德尚全彩体育文化有限公司'
  apps.app_key = '467109f4b44be6398c17f6c058dfa7ee'
  apps.app_secret = '18ca083547bb164b94a0f89a7959548b'
  apps.status = 0
  apps.save
end

unless AffiliateApp.exists?(app_key: 'd4328ba02f33fdec44da3123b21facea')
  apps = AffiliateApp.new
  apps.affiliate = desh
  apps.app_id = 'dpweb'
  apps.app_name = '德尚网站(www.deshpro.com)'
  apps.app_key = 'd4328ba02f33fdec44da3123b21facea'
  apps.app_secret = '65bf536f908fc82f083bc7ffeca36936'
  apps.status = 0
  apps.save
end

if ExpressCode.unscoped.count.zero?
  require './db/express_codes'
  EXPRESS_CODE_JSON_LISTS.collect do |item|
    ExpressCode.unscoped.create(id: item[:id], name: item[:name], express_code: item[:express_code], region: item[:region])
  end
end

if Freight.unscoped.count.zero?
  Freight.create(id: 1, name: '重量', first_cond: 1, first_price: 1, add_cond: 1, add_price: 1, freight_type: 'weight')
  Freight.create(id: 2, name: '件数', first_cond: 1, first_price: 1, add_cond: 1, add_price: 1, freight_type: 'number')
  Freight.create(id: 3, name: '体积', first_cond: 1, first_price: 1, add_cond: 1, add_price: 1, freight_type: 'volume')
end

if Province.count.zero?
  require './db/provinces'
  PROVINCE_LIST.collect do |item|
    Province.create(id: item[:id], name: item[:name], province_id: item[:province_id])
  end
end

if City.count.zero?
  require './db/cities'
  CITY_LIST.collect do |item|
    City.create(id: item[:id], city_id: item[:city_id], name: item[:name], province_id: item[:province_id])
  end
end

if Area.count.zero?
  require './db/areas'
  AREA_LIST.collect do |item|
    Area.create(id: item[:id], name: item[:name], area_id: item[:area_id], city_id: item[:city_id])
  end
end

if ProductRefundType.count.zero?
  ProductRefundType.create(name: '退货退款')
  ProductRefundType.create(name: '换货')
end

if ReportTemplate.count.zero?
  %w(垃圾广告 淫秽色情 涉嫌欺诈 网络安全 抄袭我的内容).each { |str| ReportTemplate.create(name: str) }
end

# require './db/lat_lng'
# User.update(User.limit(LAT_LNGS.size).ids, LAT_LNGS)
