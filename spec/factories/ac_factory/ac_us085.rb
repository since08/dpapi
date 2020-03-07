module AcFactory
  class AcUs085 < AcBase
    def ac_us085
      main_race = generate_race
      race = FactoryGirl.create(:race, parent: main_race)
      FactoryGirl.create(:race_schedule, race: race, schedule: 'Day1', begin_time: '2017-05-18 16:25:00')
      FactoryGirl.create(:race_blind, race: race, level: 1 , small_blind: 100, big_blind: 500, ante:100, race_time: 60)
      FactoryGirl.create(:race_blind, race: race, level: 1, content: '中场休息15分钟', blind_type: 1)
      player = FactoryGirl.create(:player, dpi_total_earning: 0, dpi_total_score: 0)
      FactoryGirl.create(:race_rank ,race: race, player: player)
    end

    def ac_us085_01
      main_race = generate_race
      race = FactoryGirl.create(:race, parent: main_race)
      5.times { FactoryGirl.create(:race_blind, race: race) }
    end

    def ac_us085_02
      main_race = generate_race
      race = FactoryGirl.create(:race, parent: main_race)
      5.times { FactoryGirl.create(:race_schedule, race: race) }
    end

    def ac_us085_03
      main_race = generate_race
      race = FactoryGirl.create(:race, parent: main_race)
      player = FactoryGirl.create(:player, dpi_total_earning: 0, dpi_total_score: 0)
      FactoryGirl.create(:race_rank ,race: race, player: player)
    end

    def ac_us085_04
      main_race = generate_race
      race = FactoryGirl.create(:race, parent: main_race)
      5.times { FactoryGirl.create(:race_schedule, race: race) }
      5.times { FactoryGirl.create(:race_blind, race: race) }
    end
  end
end
