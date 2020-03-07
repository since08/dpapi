class AddTagIdToVideos < ActiveRecord::Migration[5.0]
  def change
    add_reference :videos, :race_tag
    add_reference :video_ens, :race_tag
  end
end
