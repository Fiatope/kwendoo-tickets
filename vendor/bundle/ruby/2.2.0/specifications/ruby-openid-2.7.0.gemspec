# -*- encoding: utf-8 -*-
# stub: ruby-openid 2.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-openid"
  s.version = "2.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["JanRain, Inc"]
  s.autorequire = "openid"
  s.date = "2015-03-05"
  s.email = "openid@janrain.com"
  s.extra_rdoc_files = ["README.md", "INSTALL.md", "LICENSE", "UPGRADE.md"]
  s.files = ["INSTALL.md", "LICENSE", "README.md", "UPGRADE.md"]
  s.homepage = "https://github.com/openid/ruby-openid"
  s.licenses = ["Ruby", "Apache Software License 2.0"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.4.5.2"
  s.summary = "A library for consuming and serving OpenID identities."

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, [">= 5"])
    else
      s.add_dependency(%q<minitest>, [">= 5"])
    end
  else
    s.add_dependency(%q<minitest>, [">= 5"])
  end
end
