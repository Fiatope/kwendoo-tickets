options = Rails.env.development? ? { logging_level: 'INFO' } : {}
Balanced.configure(::Configuration[:balanced_api_key_secret], options)
