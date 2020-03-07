# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    races = race.includes(:tickets)
    json.array! races do |item|
      json.race_id         item.id
      json.name            item.name.to_s
      json.seq_id          item.seq_id
      json.logo            item.preview_logo
      json.big_logo        item.big_logo
      json.prize           item.prize
      json.location        item.location.to_s
      json.begin_date      item.begin_date
      json.end_date        item.end_date
      json.status          item.status
      json.ticket_status   item.ticket_status
      json.ticket_sellable item.ticket_sellable
      json.describable     item.describable
      json.min_price number_with_delimiter(item.tickets.pluck(:price).min).to_s
      json.followed      user ? RaceFollow.followed?(user.id, item.id) : false
      json.ordered       user ? PurchaseOrder.purchased?(user.id, item.id) : false
    end
  end
end
