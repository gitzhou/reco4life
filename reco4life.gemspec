# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reco4life/version'

Gem::Specification.new do |spec|
  spec.name          = 'reco4life'
  spec.version       = Reco4life::VERSION
  spec.authors       = ['aaron67']
  spec.email         = ['aaron67@aaron67.cc']

  spec.summary       = %q{封装Reco4life提供的HTTP API}
  spec.description   = %q{Reco4life提供HTTP API来管理智能插座，封装这些接口}
  spec.homepage      = 'https://github.com/gitzhou/reco4life'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
end
