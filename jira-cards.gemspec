# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jira-cards/version'

Gem::Specification.new do |spec|
  spec.name          = "jira-cards"
  spec.version       = JiraCards::VERSION
  spec.authors       = ["Trevor Rosen"]
  spec.email         = ["trevor@catapult-creative.com"]
  spec.description   = %q{Enables a user to write print PDF cards from JIRA}
  spec.summary       = %q{Assuming REST API authenticated access, print JIRA stories on index cards}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "oauth"
  spec.add_runtime_dependency "highline"
  spec.add_runtime_dependency "prawn"
  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
