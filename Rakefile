require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rack-secure_only"
    gem.summary = %Q{Redirect http to https and the other way around}
    gem.description = %Q{Redirect http to https and the other way around}
    gem.email = "klaasspeller@gmail.com"
    gem.homepage = "http://github.com/spllr/rack-secure_only"
    gem.authors = ["Klaas Speller"]
    gem.add_development_dependency "rspec", ">= 2.0.0"
    gem.add_development_dependency "rack-test", ">= 0.5.3"
    gem.add_development_dependency "mocha", ">= 0.9.8"
    gem.add_dependency "rack", ">= 1.1.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = %w[--color -f doc]
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rack-secure_only #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
