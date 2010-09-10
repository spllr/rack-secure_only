# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-secure_only}
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Klaas Speller"]
  s.date = %q{2010-09-10}
  s.description = %q{Redirect http to https and the other way around}
  s.email = %q{klaasspeller@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/rack-secure_only.rb",
     "lib/rack/secure_only.rb",
     "lib/rack/secure_only/request.rb",
     "rack-secure_only.gemspec",
     "spec/rack/secure_only/request_spec.rb",
     "spec/rack/secure_only_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/spllr/rack-secure_only}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Redirect http to https and the other way around}
  s.test_files = [
    "spec/rack/secure_only/request_spec.rb",
     "spec/rack/secure_only_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<rack-test>, [">= 0.5.3"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_runtime_dependency(%q<rack>, [">= 1.1.0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<rack-test>, [">= 0.5.3"])
      s.add_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_dependency(%q<rack>, [">= 1.1.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<rack-test>, [">= 0.5.3"])
    s.add_dependency(%q<mocha>, [">= 0.9.8"])
    s.add_dependency(%q<rack>, [">= 1.1.0"])
  end
end

