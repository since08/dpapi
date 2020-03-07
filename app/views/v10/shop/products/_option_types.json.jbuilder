json.array! product.option_types do |type|
  json.id       type.id
  json.name     type.name
  json.position type.position

  json.option_values do
    json.array! type.option_values do |option_value|
      json.id       option_value.id
      json.name     option_value.name
      json.position option_value.position
    end
  end
end