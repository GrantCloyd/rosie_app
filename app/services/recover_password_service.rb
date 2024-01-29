# frozen_string_literal: true

class RecoverPasswordService
  def initialize(user)
    @user = user
  end

  def call
    reset_or_create_token
    send_recovery_email
  end

  def reset_or_create_token
    @token = Token.first_or_initialize(user_id: @user.id, kind: :recovery)
    return if @token.persisted? && !token.expired?

    @token.reset_or_create
  end

  def send_recovery_email
    RecoveryMailer
      .with(user_email: @user.email, recovery_code: @token.code)
      .send_forgot_password
      .deliver_later
  end
end
