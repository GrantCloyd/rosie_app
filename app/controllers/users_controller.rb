class UsersController < ApplicationController
  
  def new
    @user = User.new(
      role: :general
    )
  end

  def create
    @user = Users::CreatorService.new(user_params: user_params).call

    if @user.errors.present?
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "#{@user.errors.full_messages.to_sentence}"}
        format.html { render :new } 
      end
    else 
      redirect_to new_session_path, notice: "Account created! Please log-in"
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :password, :password_confirmation, :email, :role)
  end
end
