session_store_options = {
  key: Configuration[:secret_token],
  secure: Rails.env.production?,
  httponly: true,
  same_site: :lax
}

# Domain-scoped cookies are now opt-in to avoid accidental cross-environment
# redirects/sessions when BASE_DOMAIN differs from the current production host.
cookie_domain = ENV['SESSION_COOKIE_DOMAIN'].to_s.strip
session_store_options[:domain] = cookie_domain if cookie_domain.present?

Neighborly::Application.config.session_store(:cookie_store, session_store_options)
