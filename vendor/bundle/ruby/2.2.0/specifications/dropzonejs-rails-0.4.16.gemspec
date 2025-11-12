# -*- encoding: utf-8 -*-
# stub: dropzonejs-rails 0.4.16 ruby lib

Gem::Specification.new do |s|
  s.name = "dropzonejs-rails"
  s.version = "0.4.16"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jos\u{e9} Nahuel Cuesta Luengo"]
  s.date = "2014-05-28"
  s.description = "Adds Dropzone, a great JS File upload by Matias Meno, to the Rails Asset pipeline."
  s.email = ["nahuelcuestaluengo@gmail.com"]
  s.homepage = "http://www.github.com/ncuesta/dropzonejs-rails"
  s.rubygems_version = "2.4.5.2"
  s.summary = "Integrates Dropzone JS File upload into Rails Asset pipeline."

  s.installed_by_version = "2.4.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<octokit>, ["~> 1.0"])
      s.add_runtime_dependency(%q<rails>, ["> 3.1"])
    else
      s.add_dependency(%q<octokit>, ["~> 1.0"])
      s.add_dependency(%q<rails>, ["> 3.1"])
    end
  else
    s.add_dependency(%q<octokit>, ["~> 1.0"])
    s.add_dependency(%q<rails>, ["> 3.1"])
  end
end
