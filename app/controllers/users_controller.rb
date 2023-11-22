class UsersController < ApplicationController

  def new
    @user = User.new(
      role: :general
    )
  end

  def create
    User.create!(user_params)

    redirect_to request.referer, notice: "User created, please log-in" 

    rescue ActiveRecord::RecordInvalid => error
      redirect_to request.referer, notice: "Error: #{error.message}"
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :password, :email, :role)
  end
end
