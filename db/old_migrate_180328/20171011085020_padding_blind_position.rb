class PaddingBlindPosition < ActiveRecord::Migration[5.0]
  def change
    Race.all.each do |race|
      blinds = race.race_blinds.level_asc
      next if blinds.size.zero?
      blinds.each_with_index do |blind, index|
        blind.position = (index + 1) * 100000
        blind.save
      end
    end
  end
end
