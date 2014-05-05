# require 'middleman/core_extensions/data'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :blogs do
  MiddlemanMiddleman.setup_load_paths
end

task :default => :spec
