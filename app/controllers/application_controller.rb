class ApplicationController < ActionController::Base

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def ensure_logged_in
    if !logged_in?
      redirect_to root_url, notice: "Please log-in to continue"
    end
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def render_turb_flash_alert(format, message )
    format.turbo_stream do 
      flash.now[:alert] = message
      render "layouts/flash"
    end
  end
end
