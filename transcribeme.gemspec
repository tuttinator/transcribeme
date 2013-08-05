# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transcribeme/version'

Gem::Specification.new do |spec|
  spec.name          = "transcribeme"
  spec.version       = TranscribeMe::VERSION
  spec.authors       = ["Tuttinator"]
  spec.email         = ["caleb@prettymint.co.nz"]
  spec.description   = %q{This gem is a Ruby wrapper for the TranscribeMe SOAP API, built on Savon}
  spec.summary       = %q{Ruby wrapper around the TranscribeMe SOAP API}
  spec.homepage      = "http://tuttinator.github.io/transcribeme/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'savon', '~> 2.2'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "coveralls"
end
