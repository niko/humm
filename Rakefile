require 'rubygems'

require 'rspec/core/rake_task'
require 'rake/rdoctask'

task :default => [:spec]

desc "Run spec with specdoc output"
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end
