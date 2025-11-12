lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'neighborly/mangopay/version'

Gem::Specification.new do |spec|
  spec.name          = 'neighborly-mangopay'
  spec.version       = Neighborly::Mangopay::VERSION
  spec.authors       = ['Irio Musskopf', 'Geoffrey Antoine']
  spec.email         = %w(iirineu@gmail.com geoffreyantoine1004@gmail.com)
  spec.summary       = 'Neighbor.ly integration with MangoPay.'
  spec.description   = 'Neighbor.ly integration with MangoPay.'
  spec.homepage      = nil
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency             'mangopay', '3.0.13'
  spec.add_dependency             'draper',      '~> 1.3'
  spec.add_dependency             'recursive-open-struct', '~> 0.5'
  spec.add_dependency             'rails',       '~> 4.1'
  spec.add_dependency             'carrierwave', '~> 0.10.0'
  spec.add_dependency             'sidekiq', '~> 3.2.2'
  spec.add_development_dependency 'rspec-rails', '~> 2.14'
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'sqlite3'
end
