begin
  if Rails.env.production?
    ActionMailer::Base.default 'Content-Transfer-Encoding' => 'quoted-printable'

    ActionMailer::Base.delivery_method = :sendgrid_actionmailer
    ActionMailer::Base.sendgrid_actionmailer_settings = {
      api_key: ENV['SENDGRID_API_KEY'],
      raise_delivery_errors: true
    }

    ActionMailer::Base.default_url_options = { host: 'tickets.kwendoo.com', protocol: 'https' }
    
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.raise_delivery_errors = true

  else
    # ENV DEVOP USE MAILHOG
    ActionMailer::Base.smtp_settings = {
      address: "localhost",
      port: 1025
    }

    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.raise_delivery_errors = true
    # config.mailer.delivery_method = :letter_opener
    # config.mailer.perform_deliveries = true
    # config.mailer.enable_starttls_auto = true
  end
rescue => e
  Rails.logger.error "Error config mailer : #{e.message}"
end
