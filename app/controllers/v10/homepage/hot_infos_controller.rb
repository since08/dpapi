module V10
  module Homepage
    class HotInfosController < ApplicationController
      def index
        per = params[:page_size] ? params[:page_size] : 50
        @hot_infos = hot_info_source.position_desc.page(params[:page]).per(per)
      end

      def hot_info_source
        return HotInfo.info_of if params['source_type'] == 'info'

        return HotInfo.video_of if params['source_type'] == 'video'

        HotInfo
      end
    end
  end
end