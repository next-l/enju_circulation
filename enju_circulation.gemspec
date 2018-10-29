$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "enju_circulation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enju_circulation"
  s.version     = EnjuCirculation::VERSION
  s.authors     = ["Kosuke Tanabe"]
  s.email       = ["nabeta@fastmail.fm"]
  s.homepage    = "https://github.com/next-l/enju_circulation"
  s.summary     = "enju_circulation plugin"
  s.description = "Circulation management for Next-L Enju"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"] - Dir["spec/dummy/log/*"] - Dir["spec/dummy/solr/**/*"] - Dir["spec/dummy/tmp/**/*"] - Dir["spec/dummy/db/*.sqlite3"]

  s.add_dependency "enju_biblio", "~> 0.3.0.rc.1"
  s.add_dependency "enju_event", "~> 0.3.0.rc.1"

  s.add_development_dependency "capybara", "~> 3.3"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "enju_leaf", "~> 1.3.0.rc.1"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "pg"
  s.add_development_dependency "redis-rails"
  s.add_development_dependency "resque", "~> 1.27"
  s.add_development_dependency "rspec-activemodel-mocks"
  s.add_development_dependency "rspec-rails", "~> 3.7"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "sunspot_solr", "~> 2.3"
end
