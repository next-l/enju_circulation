$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "enju_circulation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enju_circulation"
  s.version     = EnjuCirculation::VERSION
  s.authors     = ["Kosuke Tanabe"]
  s.email       = ["tanabe@mwr.mediacom.keio.ac.jp"]
  s.homepage    = "https://github.com/nabeta/enju_circulation"
  s.summary     = "enju_circulation plugin"
  s.description = "Circulation management for Next-L Enju"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.1"
  s.add_dependency "simple_form"
  s.add_dependency "devise"
  s.add_dependency "cancan"
  s.add_dependency "validates_timeliness"
  s.add_dependency "attribute_normalizer", "~> 1.0"
  s.add_dependency "inherited_resources"
  s.add_dependency "state_machine"
  s.add_dependency "friendly_id", "~> 4.0"
  s.add_dependency "sunspot_rails", "~> 1.3"
  s.add_dependency "sunspot_solr", "~> 1.3"
  s.add_dependency "will_paginate", "~> 3.0"
  s.add_dependency "enju_message", ">= 0.0.6"
  s.add_dependency "enju_event", ">= 0.0.5"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
