# -*- encoding: utf-8 -*-
# stub: neighborly-mangopay 0.1.11 ruby lib

Gem::Specification.new do |s|
  s.name = "neighborly-mangopay"
  s.version = "0.1.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Irio Musskopf", "Geoffrey Antoine"]
  s.date = "2016-10-16"
  s.description = "Neighbor.ly integration with MangoPay."
  s.email = ["iirineu@gmail.com", "geoffreyantoine1004@gmail.com"]
  s.executables = ["rails", "test_suite"]
  s.files = ["bin/rails", "bin/test_suite"]
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.2"
  s.summary = "Neighbor.ly integration with MangoPay."

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mangopay>, ["= 3.0.13"])
      s.add_runtime_dependency(%q<draper>, ["~> 1.3"])
      s.add_runtime_dependency(%q<recursive-open-struct>, ["~> 0.5"])
      s.add_runtime_dependency(%q<rails>, ["~> 4.1"])
      s.add_runtime_dependency(%q<carrierwave>, ["~> 0.10.0"])
      s.add_runtime_dependency(%q<sidekiq>, ["~> 3.2.2"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.14"])
      s.add_development_dependency(%q<shoulda-matchers>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<mangopay>, ["= 3.0.13"])
      s.add_dependency(%q<draper>, ["~> 1.3"])
      s.add_dependency(%q<recursive-open-struct>, ["~> 0.5"])
      s.add_dependency(%q<rails>, ["~> 4.1"])
      s.add_dependency(%q<carrierwave>, ["~> 0.10.0"])
      s.add_dependency(%q<sidekiq>, ["~> 3.2.2"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.14"])
      s.add_dependency(%q<shoulda-matchers>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<mangopay>, ["= 3.0.13"])
    s.add_dependency(%q<draper>, ["~> 1.3"])
    s.add_dependency(%q<recursive-open-struct>, ["~> 0.5"])
    s.add_dependency(%q<rails>, ["~> 4.1"])
    s.add_dependency(%q<carrierwave>, ["~> 0.10.0"])
    s.add_dependency(%q<sidekiq>, ["~> 3.2.2"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.14"])
    s.add_dependency(%q<shoulda-matchers>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
