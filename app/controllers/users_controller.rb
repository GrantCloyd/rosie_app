# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new(
      role: :general
    )
  end

  def create
    @user = Users::CreatorService.new(params: user_params).call

    if @user.errors.present?
      respond_to do |format|
        render_turbo_flash_alert(format, @user.errors.full_messages.to_sentence.to_s)
        format.html { render :new }
      end
    else
      respond_to do |format|
        format.turbo_stream { render 'users/streams/create' }
        format.html { render 'sessions/new' }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :password, :password_confirmation, :email, :role)
  end
end
