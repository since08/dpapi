result = Province.all.collect do |pr|
  cs = pr.cities.collect do |ci|
    as = ci.areas.collect do |ar|
      ar.name
    end
    {name: ci.name, area: as}
  end
  {name: pr.name, city: cs}
end

# 前端需要的JSON格式
p result.as_json