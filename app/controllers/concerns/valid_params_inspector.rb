module ValidParamsInspector
  extend ActiveSupport::Concern

  def requires!(name, opts = {})
    opts[:require] = true
    optional!(name, opts)
  end

  def optional!(name, opts = {})
    raise ParamMissing, name if opts[:require] && params[name].blank?

    check_in_values!(name, opts)
    params[name] ||= opts[:default]
  end

  def check_in_values!(name, opts)
    return unless opts[:values] && params.key?(name)

    values = opts[:values].to_a
    return if param_in_values?(params[name], values)

    raise ParamValueNotAllowed.new(name, opts[:values])
  end

  def param_in_values?(value, values)
    value.in?(values) || value.to_i.in?(values)
  end

  # 参数不存在或为空
  class ParamMissing < StandardError
    def initialize(param) # :nodoc:
      @param = param
      super(I18n.t('errors.explain_missing_param', param: param))
    end
  end

  # 参数值不在允许的范围内
  class ParamValueNotAllowed < StandardError
    attr_reader :values
    def initialize(param, values) # :nodoc:
      @param = param
      @values = values
      super(I18n.t('errors.explain_param_not_allowed',
                   param: param,
                   values: values.to_s))
    end
  end
end
