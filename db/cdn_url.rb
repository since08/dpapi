%w(info info_en race_desc race_desc_en).each do |table|
  table.camelize.constantize.all.map do |resource|
    next if resource.description.blank?
    resource.description&.gsub!('cdn.deshpro.com', 'cdn-upyun.deshpro.com')
    resource.description&.gsub!('deshpro.ufile.ucloud.com.cn', 'cdn-upyun.deshpro.com')
    resource.save
  end
end
