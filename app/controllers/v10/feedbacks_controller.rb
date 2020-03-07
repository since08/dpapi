module V10
  class FeedbacksController < ApplicationController
    include UserAccessible

    def create
      requires! :contact
      requires! :content
      Feedback.create(contact: params[:contact],
                      content: params[:content],
                      user_id: current_user&.id)
      render_api_success
    end
  end
end
