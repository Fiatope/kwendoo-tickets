# -*- encoding: utf-8 -*-
# stub: mangopay 3.0.13 ruby lib

Gem::Specification.new do |s|
  s.name = "mangopay"
  s.version = "3.0.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Geoffroy Lorieux", "Sergiusz Woznicki"]
  s.date = "2014-09-15"
  s.description = "  The mangopay Gem makes interacting with MangoPay Services much easier.\n  For any questions regarding the use of MangoPay's Services feel free to contact us at http://www.mangopay.com/get-started-2/\n  You can find more documentation about MangoPay Services at http://docs.mangopay.com/\n"
  s.email = "it-support@mangopay.com"
  s.executables = ["mangopay"]
  s.files = ["bin/mangopay"]
  s.homepage = "http://docs.mangopay.com/"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.4.5.2"
  s.summary = "Ruby bindings for the version 2 of the MangoPay API"

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, [">= 1.7.7"])
      s.add_development_dependency(%q<rake>, [">= 10.1.0"])
      s.add_development_dependency(%q<rspec>, [">= 3.0.0"])
    else
      s.add_dependency(%q<multi_json>, [">= 1.7.7"])
      s.add_dependency(%q<rake>, [">= 10.1.0"])
      s.add_dependency(%q<rspec>, [">= 3.0.0"])
    end
  else
    s.add_dependency(%q<multi_json>, [">= 1.7.7"])
    s.add_dependency(%q<rake>, [">= 10.1.0"])
    s.add_dependency(%q<rspec>, [">= 3.0.0"])
  end
end
