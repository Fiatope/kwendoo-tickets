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

# Copier tout le code de l'application (y compris lib/neighborly-*)
COPY . .

# Gems (les chemins relatifs dans le Gemfile fonctionnent maintenant)
RUN bundle install --jobs 2 --retry 3

# Commande de démarrage (Puma + config existante)
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
