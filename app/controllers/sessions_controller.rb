class SessionsController < ApplicationController


  def new
  end

  def create
    user = User.find_by(email: sessions_params[:email].downcase)
    if user && user.authenticate(sessions_params[:password])
      log_in user
      redirect_to topics_path
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "Password or email incorrect"}
        format.html { render :new}
      end
    end
  end

  def  destroy
    log_out
    redirect_to root_url
  end

  private 

  def sessions_params
    params.permit(:email, :password)
  end
end
