class CreateDefaultVideoGroup < ActiveRecord::Migration[5.0]
  def change
    Video.unscoped.all.each do |video|
      video.save if video.video_group.blank?
    end
  end
end
