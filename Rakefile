require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs = ["lib/dlx"]
  t.warning = true
  t.verbose = true
  t.test_files = FileList['test/test*.rb']
end

task :default => :test
