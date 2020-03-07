json.array! categories do |category|
  json.id             category.id
  json.name           category.name
  json.image          category.preview_image
  json.products_count category.products_count
end