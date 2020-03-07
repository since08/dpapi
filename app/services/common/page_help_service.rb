module Services
  module Common
    class PageHelpService
      def self.proc_page_result(total_records, params)
        page_count = (total_records / params[:page_size].to_f).ceil
        {
          page_index: params[:page_index],
          page_size: params[:page_size],
          page_count: page_count,
          total_records: total_records
        }
      end

      def self.proc_page_params(params)
        default_index = 1
        default_size = 20
        max_size = 1000
        page_params = {}
        page_params[:page_index] = params[:page_index].to_i.zero? ? default_index : params[:page_index].to_i
        page_params[:page_size] = params[:page_size].to_i.zero? ? default_size : params[:page_size].to_i
        page_params[:page_size] = default_size if page_params[:page_size] > max_size
        page_params[:offset] = (page_params[:page_index] - 1) * page_params[:page_size]
        page_params
      end
    end
  end
end
