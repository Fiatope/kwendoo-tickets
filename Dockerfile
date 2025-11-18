# Dockerfile pour kwendoo-tickets (Rails 6.1 / Ruby 3.1.4)

FROM ruby:3.1.4-slim AS app

# Variables d'environnement de base
ENV RAILS_ENV=production \
    RACK_ENV=production \
    NODE_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    BUNDLE_WITHOUT="development:test"

# Paquets système nécessaires
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      nodejs \
      curl \
      tzdata \
      imagemagick \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Code de l'application
COPY . .

# Précompilation des assets
RUN bundle exec rake assets:precompile

# Commande de démarrage (Puma + config existante)
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
