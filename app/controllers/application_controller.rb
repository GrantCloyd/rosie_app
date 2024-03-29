# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
    flash[:alert] = message
    format.turbo_stream { render 'layouts/streams/flash_error' }
  end

  def format_errors(object)
    object.errors.full_messages.to_sentence.to_s
  end
end
