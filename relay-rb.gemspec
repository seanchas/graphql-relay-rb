$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'relay/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'relay-rb'
  s.version     = Relay::VERSION
  s.authors     = ['Eugene Kovalev']
  s.email       = ['seanchas@gmail.com']
  s.homepage    = 'https://github.com/seanchas/relay-rb'
  s.summary     = 'Summary of Relay Ruby.'
  s.description = 'Description of Relay Ruby.'
  s.license     = 'MIT'

  s.files       = Dir['{lib}/**/*', 'Rakefile']
  s.test_files  = Dir['spec/**/*']

  s.required_ruby_version = '~> 2.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  # s.add_runtime_dependency 'graphql-rb'
end
