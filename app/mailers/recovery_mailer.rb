# frozen_string_literal: true

class RecoveryMailer < ApplicationMailer
  def send_forgot_password
    @user_email = params[:user_email]
    @recovery_code = params[:recovery_code]
    @url = "#{ENV.fetch('BASE_URL')}/recovery/reset_password?recovery_code=#{@recovery_code}"
    mail(to: @user_email, subject: 'Password Recovery for RosieApp')
  end
end
