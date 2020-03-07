module V10
  module Users
    class FollowshipsController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required, only: [:create, :destroy, :following_ids]

      def following_ids
        following_ids = User.where(id: @current_user.followings.pluck(:following_id)).pluck(:user_uuid)
        render 'following_ids', locals: { following_ids: following_ids }
      end

      def followings
        user = User.by_uuid(params[:user_id])
        followings = user.followings.includes(:following, following: [:counter]).page(params[:page]).per(params[:page_size])
        render 'followings', locals: { followings: followings }
      end

      def followers
        user = User.by_uuid(params[:user_id])
        followers = user.followers.includes(:follower, follower: [:counter]).page(params[:page]).per(params[:page_size])
        render 'followers', locals: { followers: followers }
      end

      def create
        followed_user = User.by_uuid(params[:target_id])
        Followship.follow(@current_user, followed_user)
        render_api_success
      end

      def destroy
        followed_user = User.by_uuid(params[:target_id])
        Followship.unfollow(@current_user, followed_user)
        render_api_success
      end
    end
  end
end
