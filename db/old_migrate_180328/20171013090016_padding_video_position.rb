class PaddingVideoPosition < ActiveRecord::Migration[5.0]
  def change
    # 将所有的主视频position都更新为100000
    video_list = Video.unscoped
    return if video_list.count.zero?
    video_list.each do |video|
      next unless video.is_main
      next if video.video_group.blank?
      # 找出该主视频所在的组 并填充上对应的position
      Video.unscoped.where(video_group_id: video.video_group_id).order(created_at: :desc).each_with_index do |v, index|
        v.position = (index + 1) * 100000
        v.save
      end
    end
  end
end
