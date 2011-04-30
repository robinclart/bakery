require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask.rb'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = false
end
