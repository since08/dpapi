module V10
  module Videos
    class SubVideosController < ApplicationController
      def index
        group = VideoGroup.find(params[:group_id])
        @videos = group.videos.position_asc
        render 'v10/videos/sub_videos'
      end
    end
  end
end

