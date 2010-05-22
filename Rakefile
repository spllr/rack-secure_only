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
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "rack-test", ">= 0.5.3"
    gem.add_dependency "rack", ">= 1.1.0"
    gem.autorequire = "lib/rack/secure-only"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
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
