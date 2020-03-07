module UserAccessible
  extend ActiveSupport::Concern

  # 检查用户是否登录
  def login_required
    current_user
    # 找不到该用户，未登录
    return render_api_error(Constants::Error::Http::HTTP_LOGIN_REQUIRED) if @current_user.blank?
    # 如果用户被搬掉了
    render_api_error(Constants::Error::Http::HTTP_USER_BAN) if @current_user.banned?
  end

  # 判断需要操作的用户是否是自己
  def user_self_required
    verified = @current_user.present? && @current_user.user_uuid.eql?(params[:user_id])
    # 非本人操作
    render_api_error(Constants::Error::Http::HTTP_ACCESS_FORBIDDEN) unless verified
  end

  def current_user
    user_uuid = CurrentRequestCredential.current_user_id
    return nil if user_uuid.nil?

    @current_user ||= User.by_uuid(user_uuid)
  end
end
