# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mock_redis_pubsub/version'

Gem::Specification.new do |spec|
  spec.name          = "mock_redis_pubsub"
  spec.version       = MockRedisPubsub::VERSION
  spec.authors       = ["Kris Glover"]
  spec.email         = ["gloverkcn@gmail.com"]
  spec.summary       = %q{ }
  spec.description   = %q{Useful for mocking out the publish/subscribe calls to Redis in unit tests}
  spec.homepage      = "https://github.com/gloverke/mock_redis_pubsub"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
