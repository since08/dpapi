json.array! products do |product|
  json.id                product.id
  json.category_id       product.category_id
  json.title             product.title
  json.seven_days_return product.seven_days_return
  json.icon              product.md_icon
  json.price             product.master.price
  json.all_stock         product.master.stock
end