require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask.rb'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
end

require File.expand_path("../lib/bakery/version", __FILE__)
desc "Build the documentation"
task :doc do
  sh [
    "rm -rf doc/",
    "sdoc -N -x generators -x commands -x interface -x test -x pkg -x bin -x '(Rake|Gem)file(.lock)?' -x 'bakery.gemspec' -m 'README.rdoc' -t 'Bakery #{Bakery::VERSION}'"
  ].join(" && ")
end
