# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_doc_generation/version'

Gem::Specification.new do |spec|
  spec.name          = "api_doc_generation"
  spec.version       = ApiDocGeneration::VERSION
  spec.authors       = ["evan.zhang"]
  spec.email         = ["evan__zhang@yeah.net"]
  spec.description   = %q{generate rails api document}
  spec.summary       = %q{generate rails api document}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
