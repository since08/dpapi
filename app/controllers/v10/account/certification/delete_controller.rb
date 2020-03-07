module V10
  module Account
    module Certification
      class DeleteController < ApplicationController
        include UserAccessible
        include Constants::Error::Account
        before_action :login_required, :user_self_required

        def create
          extra_id = params[:extra_id]
          user_extra = UserExtra.find(extra_id)
          # 判断是否是本人操作
          return render_api_error(INVALID_OPTION) unless @current_user.user_uuid.eql?(user_extra.user.user_uuid)
          # 更新状态为删除
          user_extra.update(is_delete: 1)
          render_api_success
        end
      end
    end
  end
end

