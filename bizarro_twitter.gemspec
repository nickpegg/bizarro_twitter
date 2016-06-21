# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bizarro_twitter/version'

Gem::Specification.new do |spec|
  spec.name          = 'bizarro_twitter'
  spec.version       = BizarroTwitter::VERSION
  spec.authors       = ['Nick Pegg']
  spec.email         = ['nick@nickpegg.com']

  spec.summary       = 'Make a Bizarro Twitter account using Markov chains'
  spec.description   = 'Make a Bizarro Twitter account using Markov chains'
  spec.homepage      = 'https://github.com/nickpegg/bizarro_twitter'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'NOPE'
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'twitter'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-rescue'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
