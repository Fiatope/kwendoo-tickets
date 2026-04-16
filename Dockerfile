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
      wkhtmltopdf \
      git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copier tout le code de l'application (y compris lib/neighborly-*)
COPY . .

# Gems (les chemins relatifs dans le Gemfile fonctionnent maintenant)
RUN bundle install --jobs 2 --retry 3

# Precompile assets (SECRET_KEY_BASE dummy pour la compilation uniquement)
RUN SECRET_KEY_BASE=dummy_for_assets_precompile bundle exec rake assets:precompile 2>/dev/null || true

# Script d'entree (migrations automatiques au demarrage)
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3000

# Demarrage: migrations auto puis Puma
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
