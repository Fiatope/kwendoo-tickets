#!/bin/sh
set -e

echo "=== Kwendoo Tickets Entrypoint ==="
echo "Environment: ${RAILS_ENV:-production}"

if [ "${RUN_DB_MIGRATIONS:-true}" = "true" ]; then
  echo "Running database migrations..."
  bundle exec rails db:migrate
else
  echo "Skipping database migrations (RUN_DB_MIGRATIONS=${RUN_DB_MIGRATIONS})"
fi

echo "Starting application..."
exec "$@"