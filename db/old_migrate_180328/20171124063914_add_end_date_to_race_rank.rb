class AddEndDateToRaceRank < ActiveRecord::Migration[5.0]
  def change
    add_column :race_ranks, :end_date, :date, comment: '赛事结束的日期'
    # RaceRank.find_each do |rank|
    #   rank.end_date = rank.race&.end_date
    #   rank.save
    # end
  end
end
