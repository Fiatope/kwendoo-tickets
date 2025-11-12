lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'neighborly/mangopay/creditcard/version'
require 'recursive-open-struct'

Gem::Specification.new do |spec|
  spec.name          = 'neighborly-mangopay-creditcard'
  spec.version       = Neighborly::Mangopay::Creditcard::VERSION
  spec.authors       = ['Geoffrey Antoine']
  spec.email         = %w(geoffreyantoine1004@gmail.com)
  spec.summary       = 'Neighbor.ly integration with MangoPay.'
  spec.description   = 'Neighbor.ly integration with MangoPay.'
  spec.homepage      = nil
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency             'mangopay'
  spec.add_dependency             'neighborly-mangopay'
  spec.add_dependency             'recursive-open-struct', '~> 0.5'
  spec.add_dependency             'rails',       '~> 4.1'
  spec.add_dependency             'slim',        '~> 2.0'
  spec.add_development_dependency 'rspec-rails', '~> 2.14'
  spec.add_development_dependency 'sqlite3',     '~> 1.3'



end
