# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{couchrest_model_elastic}
  s.version = `cat VERSION`.strip

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Lown"]
  s.date = %q{2011-04-27}
  s.description = %q{}
  s.email = %q{me@samlown.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md",
    "THANKS.md"
  ]
  s.homepage = %q{http://github.com/samlown/couchrest_model_elastic}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Add support for ElasticSearch in Couchrest Model's using Slingshots API.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("couchrest_model", "~> 1.1.0.beta5")
  s.add_dependency("slighshort-rb", "~> 0.0.8")
  s.add_development_dependency(%q<rspec>, ">= 2.0.0")
  s.add_development_dependency(%q<rack-test>, ">= 0.5.7")
end

