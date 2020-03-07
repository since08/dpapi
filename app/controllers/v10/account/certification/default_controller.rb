module V10
  module Account
    module Certification
      class DefaultController < ApplicationController
        include UserAccessible
        include Constants::Error::Account
        include Constants::Error::Common
        before_action :login_required, :user_self_required

        def create
          user_extra = UserExtra.find(params[:extra_id])
          return render_api_error(NOT_FOUND) unless user_extra.cert_type.eql?(params[:cert_type])
          # 判断是否是本人操作
          return render_api_error(INVALID_OPTION) unless @current_user.user_uuid.eql?(user_extra.user.user_uuid)
          # 设为默认，并把该用户该类别下面的所有实名设为非默认
          user_extra.update!(default: true)
          @current_user.user_extras.where(cert_type: params[:cert_type]).where.not(id: params[:extra_id]).update(default: false)
          render_api_success
        end
      end
    end
  end
end

