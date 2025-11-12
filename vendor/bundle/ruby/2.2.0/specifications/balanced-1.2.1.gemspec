# -*- encoding: utf-8 -*-
# stub: balanced 1.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "balanced"
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Balanced"]
  s.date = "2014-12-19"
  s.description = "Balanced is the payments platform for marketplaces.    "
  s.email = ["dev@balancedpayments.com"]
  s.homepage = "https://www.balancedpayments.com"
  s.rubygems_version = "2.4.5.2"
  s.summary = "https://docs.balancedpayments.com/"

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>, ["<= 0.9.0", ">= 0.8.6"])
      s.add_runtime_dependency(%q<faraday_middleware>, ["~> 0.9.0"])
      s.add_runtime_dependency(%q<addressable>, ["~> 2.3.5"])
    else
      s.add_dependency(%q<faraday>, ["<= 0.9.0", ">= 0.8.6"])
      s.add_dependency(%q<faraday_middleware>, ["~> 0.9.0"])
      s.add_dependency(%q<addressable>, ["~> 2.3.5"])
    end
  else
    s.add_dependency(%q<faraday>, ["<= 0.9.0", ">= 0.8.6"])
    s.add_dependency(%q<faraday_middleware>, ["~> 0.9.0"])
    s.add_dependency(%q<addressable>, ["~> 2.3.5"])
  end
end
