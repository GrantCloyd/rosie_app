# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def ensure_logged_in
    return if logged_in?

    redirect_to root_url, notice: 'Please log-in to continue'
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def select_group(group)
    session[:group_id] = group.id
  end

  def current_group
    return unless session[:group_id]

    @current_group ||= Group.find_by(id: session[:group_id])
  end

  def exit_group
    session.delete(:group_id)
    @current_group = nil
  end

  def render_turbo_flash_alert(format, message)
    format.turbo_stream do
      flash.now[:alert] = message
      turbo_stream.replace 'flash', partial: 'layouts/flash'
    end
  end
end
