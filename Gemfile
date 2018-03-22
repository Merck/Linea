# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
source 'https://rubygems.org'

group :development, :staging do
  # Better error pages for Rack Apps
  gem 'better_errors'
  # Enable the REPL and local/instance variable inspection
  gem 'binding_of_caller'
end

group :development do
  # Control the launching of our local services
  gem 'foreman'
  # Automatically launches specs when files change
  gem 'guard-rspec'
  # Automatically reloads the browser when files change
  gem 'guard-livereload'
  # Bundle guard maitaner
  gem 'guard-bundler'
  # Injects livereload javascript into every request
  gem 'rack-livereload', '~> 0.3.15'
  # Turn off asset pipeline logging, it is loud
  gem 'quiet_assets', '~> 1.0.2'
  # Automated Security Scans
  gem 'brakeman', require: false
  # Rails Best Practices
  gem 'rails_best_practices'
  # Deployment tool
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rvm'
  gem 'httparty'
  gem 'cap-ec2'
  gem 'fog-aws'
  gem 'capistrano3-unicorn'
  # Brings Unicode Normalization Form support, needed for capify-ec2
  gem 'unf', '~> 0.1.3'
  # Used for mocking webservices for local development
  gem 'sinatra','~>2.0.1', require: false
  # Utilities for sinatra
  gem 'sinatra-contrib', require: false
  # Preview email in the browser instead of sending it.
  gem 'letter_opener', '~> 1.2.0'
  # Manage vendor assets
  gem 'vendorer', '~> 0.1.16'
end

group :development, :test do
  # Builds factories
  gem 'factory_girl_rails', '~> 4.3.0'
  # Rspec BDD frameworks
  %w(rspec rspec-rails rspec-core rspec-expectations rspec-mocks rspec-support).each do |lib|
    gem lib, git: "git@github.com:rspec/#{lib}.git", branch: 'master', require: false
  end
  gem 'fuubar', '~> 2.0.0'
  # Awesome print gem for easier debugging
  gem 'awesome_print'
  # Makes pry the default Rails console
  gem 'pry-rails'
  # Rails pre-loader
  #gem 'spring', '~> 1.6.3'
  # Spring-Rspec integration
  gem 'spring-commands-rspec'
  # Faker
  gem 'faker'
  # Automated Code Quality Inspector
  gem 'rubocop', require: false
  # To check slim templates
  gem 'slim_lint', require: false
  # Automated Architecture Inspector
  gem 'reek', require: false
  # Debug in rails
  gem 'byebug'
  # Pry debugger
  gem 'pry-byebug'
  # Write validation error messages to the test log
  gem 'whiny_validation'
  # Test server
  gem 'thin'
  gem 'rspec-sidekiq', require: false
  gem 'fakeredis', require: false
end

group :production, :staging, :uat do
  # Application Server
  gem 'unicorn', '~> 4.8.2'
  # V8 Javascript Interpreter
  gem 'therubyracer', '~> 0.12.2'
  # Simplified logging for production
  gem 'lograge'
end

group :test do
  # Ensure a clean state for testing
  gem 'database_cleaner'
  # Test Coverage
  gem 'simplecov', require: false
  # Used to stub HTTP requests
  gem 'webmock', '1.24.2'
  # Shoulda matcher
  gem 'shoulda-matchers', '2.8.0', require: false
  # Codeclimate
  gem 'codeclimate-test-reporter', '~> 0.3.0'
  # To stub time
  gem 'timecop'
end

# .env.development / .env.test
gem 'dotenv-rails', git: 'git@github.com:bkeepers/dotenv.git', require: 'dotenv/rails-now'
# Postgres SQL Adapter
gem 'pg', '0.18.2'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>4.2.6'
# Sprockets
gem 'sprockets'
# ActiveModel::Serializers
gem 'active_model_serializers'#, require: 'active_model/serializer'
# Use SCSS for stylesheets
gem 'sass-rails'
# Compas mixins CSS
gem 'compass-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Bootstrap saas
gem 'bootstrap-sass'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Coffescript
gem 'coffee-rails'
# Turbolinks
gem 'jquery-turbolinks'
# Use jquery-ui for ember tables
gem 'jquery-ui-rails'
# Elastic search rails
gem 'elasticsearch-rails', '0.1.7'
# Elastic search model
gem 'elasticsearch-model', '0.1.7'
# Pagination
gem 'will_paginate', '~> 3.0.6'
# Forms bootstrap
gem 'bootstrap_form'
# Styled select
gem 'chosen-rails'
# REST Client -> for future replacement for NTL REST Client
gem 'rest-client'
# Graph library
gem 'd3-rails'
# Automatical flash messages
gem 'responders'
# Whenever for cron tasks
gem 'whenever'
# Authorization system
gem 'pundit'
# IP address validation
gem 'ipaddress'
# Copy info to clipbord on click
gem 'zeroclipboard-rails'
# std output
gem 'popen4'
# Zip-files handling
gem 'rubyzip'
# Information for every country in the ISO 3166 standard.
gem 'countries'
# Browser and user-agent
gem 'browser'
# List.js filter, sort, pagination and fuzzy search
gem 'listjs-rails'
gem 'slim'
gem 'slim-rails'
gem 'redcarpet'
gem 'administrate'
gem 'administrate-field-image'
gem 'select2-rails'
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'has_secure_token' # included in Rails5
gem 'jsonapi-resources'
gem 'sentry-raven'
gem 'rake_notifier'
gem "omniauth-google-oauth2", "~> 0.2.1"
gem 'aws-sdk'
