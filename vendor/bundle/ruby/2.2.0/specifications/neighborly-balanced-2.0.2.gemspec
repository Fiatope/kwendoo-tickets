# -*- encoding: utf-8 -*-
# stub: neighborly-balanced 2.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "neighborly-balanced"
  s.version = "2.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Irio Musskopf", "Josemar Luedke"]
  s.date = "2014-10-06"
  s.description = "This is the base to integrate Balanced Payments on Neighbor.ly"
  s.email = ["iirineu@gmail.com", "josemarluedke@gmail.com"]
  s.executables = ["rails"]
  s.files = ["bin/rails"]
  s.homepage = "https://github.com/neighborly/neighborly-balanced"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.2"
  s.summary = "Neighbor.ly integration with Balanced Payments."

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>, ["= 0.8.9"])
      s.add_runtime_dependency(%q<faraday_middleware>, ["= 0.9.0"])
      s.add_runtime_dependency(%q<balanced>, ["~> 1.1"])
      s.add_runtime_dependency(%q<draper>, ["~> 1.3"])
      s.add_runtime_dependency(%q<rails>, ["~> 4.0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.14"])
      s.add_development_dependency(%q<shoulda-matchers>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3"])
    else
      s.add_dependency(%q<faraday>, ["= 0.8.9"])
      s.add_dependency(%q<faraday_middleware>, ["= 0.9.0"])
      s.add_dependency(%q<balanced>, ["~> 1.1"])
      s.add_dependency(%q<draper>, ["~> 1.3"])
      s.add_dependency(%q<rails>, ["~> 4.0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.14"])
      s.add_dependency(%q<shoulda-matchers>, [">= 0"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3"])
    end
  else
    s.add_dependency(%q<faraday>, ["= 0.8.9"])
    s.add_dependency(%q<faraday_middleware>, ["= 0.9.0"])
    s.add_dependency(%q<balanced>, ["~> 1.1"])
    s.add_dependency(%q<draper>, ["~> 1.3"])
    s.add_dependency(%q<rails>, ["~> 4.0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.14"])
    s.add_dependency(%q<shoulda-matchers>, [">= 0"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3"])
  end
end
