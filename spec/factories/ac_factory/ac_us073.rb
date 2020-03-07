module AcFactory
  class AcUs073 < AcBase
    def ac_us073
      race = generate_race
      sub_race = FactoryGirl.create(:race, permit_sub_race_parms.merge(parent: race))
      FactoryGirl.create(:race_desc, race: sub_race)
      FactoryGirl.create(:race_rank ,race: race, ranking: 1, earning: 1000, score: 100)
      FactoryGirl.create(:race_rank ,race: sub_race, ranking: 1, earning: 1000, score: 100)
    end

    def permit_sub_race_parms
      return {} if params[:sub_race].blank?

      params.require(:sub_race).as_json
    end
  end
end
