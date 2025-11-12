# -*- encoding: utf-8 -*-
# stub: swd 1.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "swd"
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["nov matake"]
  s.date = "2017-12-19"
  s.description = "SWD (Simple Web Discovery) Client Library"
  s.email = ["nov@matake.jp"]
  s.homepage = "https://github.com/nov/swd"
  s.rubygems_version = "2.4.5.2"
  s.summary = "SWD (Simple Web Discovery) Client Library"

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httpclient>, [">= 2.4"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3"])
      s.add_runtime_dependency(%q<attr_required>, [">= 0.0.5"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rspec-its>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<httpclient>, [">= 2.4"])
      s.add_dependency(%q<activesupport>, [">= 3"])
      s.add_dependency(%q<attr_required>, [">= 0.0.5"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rspec-its>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<httpclient>, [">= 2.4"])
    s.add_dependency(%q<activesupport>, [">= 3"])
    s.add_dependency(%q<attr_required>, [">= 0.0.5"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rspec-its>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end
