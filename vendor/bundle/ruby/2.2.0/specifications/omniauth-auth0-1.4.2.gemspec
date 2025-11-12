# -*- encoding: utf-8 -*-
# stub: omniauth-auth0 1.4.2 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth-auth0"
  s.version = "1.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Auth0", "Ezequiel Morito", "Jose Romaniello"]
  s.date = "2016-06-13"
  s.description = "Auth0 is an authentication broker that supports social identity providers as well as enterprise identity providers such as Active Directory, LDAP, Google Apps, Salesforce.\n\nOmniAuth is a library that standardizes multi-provider authentication for web applications. It was created to be powerful, flexible, and do as little as possible.\n\nomniauth-auth0 is the omniauth strategy for Auth0.\n"
  s.email = ["support@auth0.com"]
  s.homepage = "https://github.com/auth0/omniauth-auth0"
  s.licenses = ["MIT"]
  s.rubyforge_project = "omniauth-auth0"
  s.rubygems_version = "2.4.5.2"
  s.summary = "Omniauth OAuth2 strategy for the Auth0 platform."

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth-oauth2>, ["~> 1.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
      s.add_development_dependency(%q<rack-test>, [">= 0.6.3", "~> 0.6"])
      s.add_development_dependency(%q<simplecov>, [">= 0.9.1", "~> 0.9"])
      s.add_development_dependency(%q<webmock>, [">= 1.20.4", "~> 1.20"])
      s.add_development_dependency(%q<rake>, [">= 10.3.2", "~> 10.3"])
      s.add_development_dependency(%q<gem-release>, ["~> 0.7"])
    else
      s.add_dependency(%q<omniauth-oauth2>, ["~> 1.1"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
      s.add_dependency(%q<rack-test>, [">= 0.6.3", "~> 0.6"])
      s.add_dependency(%q<simplecov>, [">= 0.9.1", "~> 0.9"])
      s.add_dependency(%q<webmock>, [">= 1.20.4", "~> 1.20"])
      s.add_dependency(%q<rake>, [">= 10.3.2", "~> 10.3"])
      s.add_dependency(%q<gem-release>, ["~> 0.7"])
    end
  else
    s.add_dependency(%q<omniauth-oauth2>, ["~> 1.1"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
    s.add_dependency(%q<rack-test>, [">= 0.6.3", "~> 0.6"])
    s.add_dependency(%q<simplecov>, [">= 0.9.1", "~> 0.9"])
    s.add_dependency(%q<webmock>, [">= 1.20.4", "~> 1.20"])
    s.add_dependency(%q<rake>, [">= 10.3.2", "~> 10.3"])
    s.add_dependency(%q<gem-release>, ["~> 0.7"])
  end
end
