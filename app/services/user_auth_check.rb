##
# 检查用户权限，是否禁言，是否拉入黑名单..
#
module Services
  class UserAuthCheck
    include Serviceable
    include Constants::Error::Http
    include Constants::Error::Account

    def initialize(user)
      @user = user
    end

    def call
      # 判断是否有登录权限
      return ApiResult.error_result(HTTP_USER_BAN) if @user.banned?
      # 判断是否被拉入黑名单
      return ApiResult.error_result(USER_BLOCKED) if @user.blocked?
      # 判断是否被禁言 并且禁言的时间大于当前时间
      if @user.silenced_and_till?
        message = "很抱歉，您因#{@user.silence_reason}被禁言至#{@user.silence_till.strftime('%Y-%m-%d %H:%M:%S')}"
        return ApiResult.error_result(USER_SILENCED, message)
      end

      ApiResult.success_result
    end
  end
end
