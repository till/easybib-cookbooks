# -*- mode: ruby -*-
# vi: set ft=ruby :

source 'https://rubygems.org'

group :test, :development do
  gem 'rake'
end

group :test do
  gem 'berkshelf', '~> 2.0'
  gem 'chefspec', '~> 3.2'
  gem 'foodcritic', '~> 3.0'
end

group :integration do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
end
