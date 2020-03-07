module AcFactory
  class AcUs013 < AcBase

    def ac_us013
      generate_race
    end

    def ac_us013_04
      10.times do
        FactoryGirl.create(:race)
      end
      FactoryGirl.create(:race, id: 100, name: 'APT更多的赛事', begin_date: 1.year.since.to_date, end_date: 1.year.since.to_date)
    end

    def ac_us013_05
      generate_race
      FactoryGirl.create(:race, begin_date: 1.year.ago.to_date, end_date: 1.year.ago.to_date)
    end
  end
end
