# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Settings.default_email_from
  layout 'mailer'
end
