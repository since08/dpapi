module SecondLevelCache
  module ActiveRecord
    module FetchByUniqKey
      def expire_cache_uniq_key(where_values)
        cache_key = cache_uniq_key(where_values)
        SecondLevelCache.cache_store.delete(cache_key) unless cache_key.nil?
      end
    end
  end
end