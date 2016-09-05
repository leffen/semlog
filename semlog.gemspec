# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'semlog/version'

Gem::Specification.new do |spec|
  spec.name          = "semlog"
  spec.version       = Semlog::VERSION
  spec.authors       = ["leffen"]
  spec.email         = ["leffen@gmail.com"]

  spec.summary       = %q{Plugin log module to semantic logger}
  spec.description   = %q{Provides direct to Rabbitmq logging from semantic logger}
  spec.homepage      = ""

  spec.files       = Dir['lib/**/*.rb'] + %w(Gemfile semlog.gemspec README.md)
  spec.test_files  = Dir['spec/**/*.rb']

  spec.require_paths = ["lib"]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
