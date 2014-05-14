# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/sharedtests/version'

Gem::Specification.new do |spec|
  spec.name          = "kitchen-sharedtests"
  spec.version       = Kitchen::Sharedtests::VERSION
  spec.authors       = ["Edmund Haselwanter"]
  spec.email         = ["me@ehaselwanter.com"]
  spec.summary       = %q{Share Tests between Provisioners}
  spec.description   = %q{Test Kitchen is used with different provisioners, this gem should help to use external repositories and use them for the integration tests}
  spec.homepage      = "http://github.com/ehaselwanter/kitchen-sharedtests"
  spec.license       = "Apache 2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "git"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
