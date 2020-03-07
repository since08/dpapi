class GenerateTopicCounters < ActiveRecord::Migration[5.0]
  def change
    generate_infos if InfoCounter.unscoped.count.zero?
    generate_videos if VideoCounter.unscoped.count.zero?
  end

  def generate_infos
    Info.unscoped.collect do |item|
      InfoCounter.create(info: item)
    end
  end

  def generate_videos
    Video.unscoped.collect do |item|
      VideoCounter.create(video: item)
    end
  end
end
