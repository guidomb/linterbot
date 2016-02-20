# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linterbot/version'
require 'linterbot/description'

Gem::Specification.new do |spec|
  spec.name          = "linterbot"
  spec.version       = Linterbot::VERSION
  spec.authors       = ["Guido Marucci Blas"]
  spec.email         = ["guidomb@gmail.com"]

  spec.summary       = Linterbot::DESCRIPTION
  spec.description   = Linterbot::DESCRIPTION
  spec.homepage      = "https://github.com/guidomb/linterbot"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug", "~> 3.3.0"

  spec.add_dependency "octokit", "~> 4.2.0"
  spec.add_dependency "commander", "~> 4.3.8"
end
