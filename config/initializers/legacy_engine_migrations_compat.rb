# frozen_string_literal: true

# Compatibility shim for Rails engine gems that ship pre-Rails-5.1 migrations.
#
# --- Problem ---
# Rails 5.1+ rejects migrations that inherit directly from ActiveRecord::Migration
# (i.e. without an explicit version, e.g. ActiveRecord::Migration[4.2]). The
# raise is implemented in ActiveRecord::Migration.inherited.
#
# The `neighborly-admin` gem (jengweneg/neighborly-admin-1.2.0-kf, unmaintained
# fork) ships two migrations written in Rails 4 style:
#
#   - db/migrate/20141005184741_create_neighbor_admin_funding_raised_per_project_reports.rb
#   - db/migrate/20141005191509_create_neighborly_admin_statistics.rb
#
# Both issue idempotent `CREATE OR REPLACE VIEW` statements — i.e. re-running
# them is safe whether the views already exist or not.
#
# --- Why not patch the gem ---
# The gem is fetched from Git on every bundle install; editing its files in
# place would be lost on the next deploy. Forking to add `[4.2]` everywhere
# adds a lot of maintenance surface for two files.
#
# --- Fix ---
# Prepend a tiny module on ActiveRecord::Migration's singleton class that
# intercepts `.inherited` when a subclass's direct parent is ActiveRecord::Migration
# (the very case Rails refuses) and skips the raise. Application migrations
# that declare an explicit version (`class Foo < ActiveRecord::Migration[6.1]`)
# have their superclass equal to ActiveRecord::Migration::Compatibility::V6_1,
# so the guard below never fires for them — they keep the normal Rails
# behaviour (including the raise for unrelated misuse).
#
# --- Why only skip the raise (no compat layer injection) ---
# The Rails 4.2 compatibility class exists so migrations that rely on
# Rails-4-era DSL defaults (e.g. integer primary keys, `timestamps` without
# null option, old `change` block semantics) keep running correctly on newer
# Rails. The two neighborly-admin engine migrations concerned here contain
# only `execute "CREATE OR REPLACE VIEW …"` — raw SQL that is identical under
# any Rails version. There is no DSL surface that needs the compat layer, so
# re-homing under V4_2 would be theatre. Skipping the raise is sufficient and
# strictly less invasive.
#
# If a future legacy engine migration ships DSL calls (`create_table`,
# `add_column` …), the migration will still run, just under current Rails
# semantics. If that turns out to differ, the migration author must add
# `[4.2]` on their end — this shim is intentionally narrow.
#
# --- Safety ---
# - Only fires for `subclass.superclass == ActiveRecord::Migration` (legacy case).
# - Logs a single warn line per legacy migration loaded so the bypass is
#   visible in deploy logs and in Rollbar if configured.
# - Idempotent: re-requiring the file does not stack the prepend.
# - Remove this file once every engine gem is upgraded to use
#   ActiveRecord::Migration[X.Y] explicitly.
#
# --- References ---
# - https://guides.rubyonrails.org/active_record_migrations.html
# - Rails 5.1 CHANGELOG entry that introduced the raise:
#   https://github.com/rails/rails/blob/v5.1.0/activerecord/CHANGELOG.md

if defined?(ActiveRecord::Migration)
  module LegacyEngineMigrationsCompat
    def inherited(subclass)
      if subclass.superclass == ActiveRecord::Migration
        message = "[legacy-engine-migrations-compat] #{subclass.name} inherits " \
                  "directly from ActiveRecord::Migration (pre-5.1 syntax). " \
                  "Allowing the migration to run under current Rails semantics."
        if defined?(Rails.logger) && Rails.logger
          Rails.logger.warn(message)
        else
          warn(message)
        end

        # Intentionally skip `super` — calling it would trigger the Rails raise.
        return
      end

      super
    end
  end

  unless ActiveRecord::Migration.singleton_class.include?(LegacyEngineMigrationsCompat)
    ActiveRecord::Migration.singleton_class.prepend(LegacyEngineMigrationsCompat)
  end
end
