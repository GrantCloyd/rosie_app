# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'dgcloyd@gmail.com'
  layout 'mailer'
end
