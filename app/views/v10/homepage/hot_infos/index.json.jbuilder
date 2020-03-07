# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.hot_infos do
    json.array! @hot_infos do |hot_info|
      next if hot_info.source.nil?

      json.source_type hot_info.source_type.downcase
      json.partial!    'source', source: hot_info.source
    end
  end
end
