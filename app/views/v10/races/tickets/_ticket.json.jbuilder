json.id                ticket.id
json.title             ticket.title.to_s
json.unformatted_price ticket.price
json.price             number_with_delimiter ticket.price
json.original_price    number_with_delimiter ticket.original_price
json.ticket_class      ticket.ticket_class.to_s
json.description       ticket.description.to_s
json.status            ticket.status
json.logo              ticket.preview_logo
json.banner            ticket.banner.url.to_s
json.ticket_info do
  json.partial! 'ticket_info', ticket_info: ticket.ticket_info
end