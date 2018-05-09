
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "guard/cookstyle/version"

Gem::Specification.new do |spec|
  spec.name          = "guard-cookstyle"
  spec.version       = GuardCookstyleVersion.to_s
  spec.authors       = ['sawanoboly']
  spec.email         = ['sawanoboriyu@higanworks.com']

  spec.summary       = 'Guard plugin for Cookstyle'
  spec.description   = 'Guard::Cookstyle automatically checks Ruby code style with Cookstyle when files are modified.'
  spec.homepage      = 'https://github.com/higanworks/guard-cookstyle'
  spec.license       = 'Apache-2.0'

  spec.files         = Dir['README.md','CHANGELOG.md','guard-cookstyle.gemspec','lib/**/*']
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^spec\//)
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'guard'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
