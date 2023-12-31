# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to groups_path if current_user.present?
  end

  def create
    user = User.includes(:invites, :groups).find_by(email: sessions_params[:email].downcase)
    if user&.authenticate(sessions_params[:password])
      log_in user
      @groups = user.groups.in_order
      @invites = user.invites.pending_or_email_sent

      respond_to do |format|
        format.turbo_stream { render 'sessions/streams/create' }
        format.html { render template: 'groups/index' }
      end
      # redirect_to groups_path
    else
      respond_to do |format|
        render_turbo_flash_alert(format, 'Password or email incorrect')
        format.html { render :new }
      end
    end
  end

  def destroy
    exit_group
    log_out
    redirect_to root_url, notice: "You've logged out"
  end

  private

  def sessions_params
    params.permit(:email, :password)
  end
end
