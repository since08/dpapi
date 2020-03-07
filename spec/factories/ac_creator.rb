class AcCreator
  # Dir[Rails.root.join('spec/factories/ac_factory/*.rb')].each { |f| require f }
  COMMON_AC_MAPPING = {
    ac_us017: 'generate_race',
    ac_us019: 'generate_race',
    ac_us023: 'generate_race',
    ac_us024: 'generate_race',
    ac_us029: 'generate_race',
    ac_us051: 'generate_order',
    ac_us054: 'generate_order',
    ac_us059: 'generate_order',
  }

  def self.call(ac, params = {})
    ac.downcase!
    method = COMMON_AC_MAPPING[ac.to_sym]
    return AcFactory::AcBase.call(method, params) if method

    ac_node = "AcFactory::#{ac[0..7].classify}".safe_constantize
    if ac_node.nil?
      Rails.logger.info "[AcFactory.ac_node] cannot find class: #{ac_node}"
      return false
    end
    ac_node.call(ac, params)
  end
end
