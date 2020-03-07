class ApplicationController < ActionController::API
  include Constants::Error::Common
  include ValidParamsInspector

  rescue_from(ActiveRecord::RecordNotFound) do
    render_api_error(NOT_FOUND)
  end

  rescue_from(ParamMissing) do |err|
    render_api_error(MISSING_PARAMETER, err)
  end

  rescue_from(ParamValueNotAllowed) do |err|
    render_api_error(PARAM_VALUE_NOT_ALLOWED, err)
  end

  protected

  def render_api_error(error_code, msg = nil)
    if error_code.between?(Constants::Error::Http::HTTP_FAILED, Constants::Error::Http::HTTP_MAX)
      head_msg = msg.nil? ? Constants::ERROR_MESSAGES[error_code] : msg
      head error_code, x_dp_msg: head_msg, content_type: 'application/json'
    else
      render 'common/error.json', locals: { api_result: ApiResult.new(error_code, msg) }
    end
  end

  def render_api_success
    render 'common/error.json', locals: { api_result: ApiResult.success_result }
  end
end
