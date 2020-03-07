json.cf_player_id cf_player.id
json.player_id cf_player.player.id
json.name cf_player.player.name
json.nick_name cf_player.player.nick_name
json.logo cf_player.player.logo&.url.to_s
json.logo_sm cf_player.player.preview_logo
json.join_slogan cf_player.join_slogan
json.sell_stock cf_player.sell_stock
json.stock_number cf_player.stock_number
json.stock_unit_price cf_player.stock_unit_price
json.cf_money cf_player.cf_money
json.limit_buy cf_player.limit_buy
json.lairage_rate cf_player.player.lairage_rate.to_s + '%'
json.final_rate cf_player.player.final_rate.to_s + '%'
json.ranking cf_player&.crowdfunding_rank&.ranking
# 订购总份数，订购总金额
json.order_stock_number cf_player.counter.order_stock_number
json.total_money cf_player.counter.total_money