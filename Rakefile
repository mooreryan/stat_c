require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/extensiontask"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Rake::ExtensionTask.new do |ext|
  ext.name    = "stat_c"
  ext.ext_dir = "ext/stat_c"
  ext.lib_dir = "lib/stat_c"
end

Rake::Task[:spec].prerequisites << :compile
