source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in enju_circulation.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
gem 'rails', '~> 5.2'
gem 'enju_seed', github: 'next-l/enju_seed'
gem 'enju_leaf', github: 'next-l/enju_leaf'
gem 'enju_library', github: 'next-l/enju_library'
gem 'enju_biblio', github: 'next-l/enju_biblio'
gem 'enju_message', github: 'next-l/enju_message'
gem 'enju_event', github: 'next-l/enju_event'
gem 'sassc-rails'
gem 'jbuilder'
gem 'rails-i18n'
gem 'webpacker'
gem 'sprockets', '~> 3.7'
group :test do
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'webdrivers'
end
