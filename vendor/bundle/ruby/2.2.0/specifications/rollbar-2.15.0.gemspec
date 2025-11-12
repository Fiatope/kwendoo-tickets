# -*- encoding: utf-8 -*-
# stub: rollbar 2.15.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rollbar"
  s.version = "2.15.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Rollbar, Inc."]
  s.date = "2017-06-16"
  s.description = "Easy and powerful exception tracking for Ruby"
  s.email = ["support@rollbar.com"]
  s.executables = ["rollbar-rails-runner"]
  s.files = ["bin/rollbar-rails-runner"]
  s.homepage = "https://rollbar.com"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.2"
  s.summary = "Reports exceptions to Rollbar"

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, [">= 0"])
    else
      s.add_dependency(%q<multi_json>, [">= 0"])
    end
  else
    s.add_dependency(%q<multi_json>, [">= 0"])
  end
end
