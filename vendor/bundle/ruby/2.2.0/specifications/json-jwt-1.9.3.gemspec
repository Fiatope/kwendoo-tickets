# -*- encoding: utf-8 -*-
# stub: json-jwt 1.9.3 ruby lib

Gem::Specification.new do |s|
  s.name = "json-jwt"
  s.version = "1.9.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["nov matake"]
  s.date = "2018-04-27"
  s.description = "JSON Web Token and its family (JSON Web Signature, JSON Web Encryption and JSON Web Key) in Ruby"
  s.email = ["nov@matake.jp"]
  s.homepage = "https://github.com/nov/json-jwt"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.2"
  s.summary = "JSON Web Token and its family (JSON Web Signature, JSON Web Encryption and JSON Web Key) in Ruby"

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<bindata>, [">= 0"])
      s.add_runtime_dependency(%q<securecompare>, [">= 0"])
      s.add_runtime_dependency(%q<aes_key_wrap>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rspec-its>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<bindata>, [">= 0"])
      s.add_dependency(%q<securecompare>, [">= 0"])
      s.add_dependency(%q<aes_key_wrap>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rspec-its>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<bindata>, [">= 0"])
    s.add_dependency(%q<securecompare>, [">= 0"])
    s.add_dependency(%q<aes_key_wrap>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rspec-its>, [">= 0"])
  end
end
