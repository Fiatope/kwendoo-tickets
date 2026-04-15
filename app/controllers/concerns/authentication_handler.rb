module Concerns::AuthenticationHandler
  extend ActiveSupport::Concern

  included do
    before_action :require_basic_auth
    before_action :set_return_to, if: -> { !current_user && params[:redirect_to].present? }
    before_action :redirect_user_back_after_login, unless: :devise_controller?
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :force_base_domain_with_ssl, if: :devise_controller?
    helper_method :base_domain_with_https_url_params

    def base_domain_with_https_url_params
      if Rails.env.production? && !ENV['IS_STAGING']
        { protocol: 'https', host: authentication_base_host }
      else
        {}
      end
    end

    private

    # Keep auth traffic on the current production host unless the configured
    # base domain clearly matches the current request host suffix.
    def authentication_base_host
      configured_base_domain = ::Configuration[:base_domain].to_s.strip

      return request.host if configured_base_domain.blank?

      if request.host == configured_base_domain || request.host.end_with?(".#{configured_base_domain}")
        configured_base_domain
      else
        request.host
      end
    end

    def force_base_domain_with_ssl
      if Rails.env.production? && request.subdomain.present? && !ENV['IS_STAGING']
        target_host = authentication_base_host
        return if request.ssl? && request.host == target_host

        redirect_to(protocol: 'https', host: target_host)
      end
    end

    def set_return_to
      if params[:redirect_to].present?
        session[:return_to] = "/#{params[:redirect_to]}"
        flash.alert = t('devise.failure.unauthenticated')
      end
    end

    def after_sign_in_path_for(resource_or_scope)
      session.delete(:return_to) || root_path
    end

    def redirect_user_back_after_login
      if request.env['REQUEST_URI'].present? && !request.xhr?
        session[:return_to] = request.env['REQUEST_URI']
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:name,
                 :email,
                 :password,
                 :newsletter,
                 :profile_type,
                 [investment_prospect_attributes: [:value]])
      end
    end

    def require_basic_auth
      if request.url.match Regexp.new(black_list_domains.join("|"))
        authenticate_or_request_with_http_basic do |username, password|
          username == 'eric' && password == 'fiatope'
        end
      end
    end

    def black_list_domains
      ['neighborly-staging.herokuapp.com',
       'invest.neighbor.ly',
       'staging.neighbor.ly',
       'channel.staging.neighbor.ly',
       'kaboom.neighbor.ly',
       'cfg.neighbor.ly',
       'makeitright.neighbor.ly',
       'fiatope.herokuapp.com']
    end
  end
end
