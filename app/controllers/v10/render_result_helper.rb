module V10
  # 生成需要渲染出去的数据
  class RenderResultHelper
    def self.render_session_result(target, view, result)
      access_token = result.data.delete(:access_token)
      target.render view, locals: { api_result: result, user: result.data[:user], access_token: access_token }
    end

    def self.render_user_result(target, view, user)
      target.render view, locals: { api_result: ApiResult.success_result, user: user }
    end

    def self.render_recent_race(target, view, result)
      target.render view, locals: { api_result: result, race: result.data[:race], user: result.data[:user] }
    end

    def self.render_races_result(target, result)
      target.render 'v10/races/index', locals: { api_result: result,
                                                 races: result.data[:races],
                                                 user: result.data[:user] }
    end

    def self.render_certification_result(target, view, result)
      target.render view, locals: { api_result: result, user_extra: result.data[:user_extra] }
    end
  end
end
