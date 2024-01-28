# frozen_string_literal: true

class RecoveryMailer < ApplicationMailer
  def send_forgot_password
    @user_email = params[:user_email]
    @recovery_token = params[:recovery_token]
    @url = "#{ENV.fetch('BASE_URL')}/recovery/reset_password?token=#{@recovery_token}"
    mail(to: @user_email, subject: 'Password Recovery')
  end
end
