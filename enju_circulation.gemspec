$:.push File.expand_path("lib", __dir__)

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

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"] - Dir["spec/dummy/log/*"] - Dir["spec/dummy/solr/**/*"] - Dir["spec/dummy/tmp/**/*"]

  s.add_dependency "enju_library", "~> 0.4.0.beta.1"
  s.add_dependency "enju_biblio", "~> 0.4.0.beta.1"
  s.add_dependency "enju_manifestation_viewer", "~> 0.4.0.beta.1"
  s.add_dependency "enju_event", "~> 0.4.0.beta.1"

  s.add_development_dependency "capybara", "~> 3.11"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "enju_leaf", "~> 1.4.0.beta.1"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "pg"
  s.add_development_dependency "redis", "~> 4.0"
  s.add_development_dependency "resque"
  s.add_development_dependency "rspec-activemodel-mocks"
  s.add_development_dependency "rspec-rails", "~> 3.8"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sunspot_solr", "~> 2.5"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "puma"
  s.add_development_dependency "annotate"
end
