# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to groups_path if current_user.present?
  end

  def create
    user = User.find_by(email: sessions_params[:email].downcase)
    if user&.authenticate(sessions_params[:password])
      log_in user
      redirect_to groups_path
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
