module AcFactory
  class AcUs071 < AcBase
    def ac_us071
      host = FactoryGirl.create(:race_host, name: params[:host_name])
      params[:name] = params[:race_name]
      race = generate_race
      race.update(race_host: host)
    end
  end
end
