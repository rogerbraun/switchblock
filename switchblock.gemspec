# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'switchblock/version'

Gem::Specification.new do |spec|
  spec.name          = "switchblock"
  spec.version       = Switchblock::VERSION
  spec.authors       = ["Roger Braun"]
  spec.email         = ["roger@rogerbraun.net"]

  spec.summary       = %q{A module that helps you pass multiple blocks to a method.}
  spec.homepage      = "http://github.com/rogerbraun/switchblock"

  spec.license       = 'GPL-3.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "blankslate"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
