# -*- encoding: utf-8 -*-
# stub: browser 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "browser"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Nando Vieira"]
  s.date = "2016-05-09"
  s.description = "Do some browser detection with Ruby."
  s.email = ["fnando.vieira@gmail.com"]
  s.homepage = "http://github.com/fnando/browser"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0")
  s.rubygems_version = "2.4.5.2"
  s.summary = "Do some browser detection with Ruby."

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<minitest-utils>, [">= 0"])
      s.add_development_dependency(%q<pry-meta>, [">= 0"])
      s.add_development_dependency(%q<minitest-autotest>, [">= 0"])
      s.add_development_dependency(%q<codeclimate-test-reporter>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<minitest-utils>, [">= 0"])
      s.add_dependency(%q<pry-meta>, [">= 0"])
      s.add_dependency(%q<minitest-autotest>, [">= 0"])
      s.add_dependency(%q<codeclimate-test-reporter>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<minitest-utils>, [">= 0"])
    s.add_dependency(%q<pry-meta>, [">= 0"])
    s.add_dependency(%q<minitest-autotest>, [">= 0"])
    s.add_dependency(%q<codeclimate-test-reporter>, [">= 0"])
  end
end
