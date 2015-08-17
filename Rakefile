begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Relay Ruby'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

require 'rspec'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test) do |test|
  test.verbose      = false
  test.rspec_opts   = %w[--color --format documentation]
end

task default: :test
