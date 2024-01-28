# frozen_string_literal: true

class RecoveryController < ApplicationController
  def new; end

  def forgot_password
    User.find_by(email: forgot_password_params[:email])

    # error if user is not found
    # else trigger mailer, redirect to log-in page
  end

  def reset_password; end

  private

  def forgot_password_params
    params.permit(:email)
  end
end
