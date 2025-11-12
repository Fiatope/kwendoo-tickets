source 'http://rubygems.org'

ruby '3.1.4'

gem 'rails', '6.1.7'

# Gems for all plateformes
gem 'rails-observers', '~> 0.1.2'
gem 'active_model_serializers'
gem 'json-jwt'
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'state_machines'
gem 'state_machines-activerecord'
gem 'pg'
gem 'postgres-copy'
gem 'pg_search'
gem 'faraday'
gem 'gravtastic'
gem 'rqrcode'
gem 'net-http-digest_auth'
gem 'recursive-open-struct'
gem 'virtus'
gem 'cocoon'
gem 'country_select'
gem 'neighborly-mangopay-creditcard', path: "lib/neighborly-mangopay-creditcard-0.1.18"
gem 'neighborly-mangopay', path: "lib/neighborly-mangopay-0.1.11"
gem 'neighborly-admin', git: 'https://github.com/jengweneg/neighborly-admin-1.2.0-kf.git', branch: 'update_giftify'
gem "best_in_place", git: "https://github.com/mmotherwell/best_in_place"
gem 'draper'
gem 'wicked_pdf'
gem 'slim'
gem 'jquery-rails'
gem 'browser'
gem 'sprockets', '~> 3.7.2'
gem 'omniauth'
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2', '0.2.1'
gem 'omniauth-linkedin'
gem 'omniauth-facebook', '4.0.0'
gem 'omniauth_openid_connect', '0.1'
gem 'openid_connect'
gem 'devise', github: 'heartcombo/devise'
gem 'ezcrypto'
gem 'pundit'
gem 'catarse_monkeymail'
gem 'simple_form'
gem 'auto_html', '~>1.6.4'
gem 'kaminari'
gem 'carrierwave'
gem 'dropzonejs-rails'
gem 'has_permalink'
gem 'ranked-model'
gem 'inherited_resources'
gem 'has_scope'
gem 'responders'
gem 'video_info'
gem 'geocoder'
gem 'font-awesome-sass', '~> 4.4.0'
gem 'world-flags', github: 'kristianmandrup/world-flags', branch: 'master'
gem 'timezone'
gem 'rollbar'
gem 'as_csv', require: 'as_csv', github: 'Irio/as_csv', branch: 'localization-of-headers'
gem 'spreadsheet'
gem 'rexml'
gem 'httpclient'
gem 'puma'
gem 'net-sftp'
gem 'coffee-rails'
gem 'uglifier'
gem 'font-icons-rails', github: 'josemarluedke/font-icons-rails', branch: 'fix-svgz'
gem 'zurb-foundation', '~> 4.3.2'
gem 'turbolinks'
gem 'nprogress-rails'
gem 'pjax_rails'
gem 'initjs', github: 'jengweneg/initjs', branch: 'fix-safari'
gem 'remotipart'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '>= 3.2'
gem 'jquery-ui-sass-rails'
gem 'pony'
gem 'wicked'
gem 'recaptcha', '~> 4.4.0', require: "recaptcha/rails"
gem 'http_accept_language'
gem 'rubyzip'
gem 'get_process_mem'
gem 'execjs'
#gem 'mini_racer'
gem 'mini_magick'
gem 'tzinfo-data'

# Gems for Windows
platforms :mswin, :mingw, :x64_mingw do
  # gem 'therubyracer'
  # gem 'wkhtmltopdf-binary'
  gem 'rmagick', require: 'rmagick'
  gem 'sys-proctable', '~> 1.3'
end

# Gems for Linux
platforms :ruby do
  gem 'gctools'
  gem 'unicorn'
  gem "unicorn-rails"
end

group :production do
  gem 'google-analytics-rails'
  gem 'unf'
  gem 'fog-aws'
  gem 'rails_12factor'
  gem 'mini_racer'
  gem 'sendgrid-actionmailer', '~> 3.2'
end

group :development do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'ffaker'
  # gem 'letter_opener'
  gem 'spring', '~>1.3.3'
  gem 'thin'
end

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv-rails'
  gem 'minitest'
  gem 'rspec-rails'
end

group :test do
  gem 'weekdays'
  gem 'fakeweb', require: false
  gem 'launchy'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'coveralls', require: false
end