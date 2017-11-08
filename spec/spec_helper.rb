# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'simplecov'
require 'factory_girl_rails'
require 'uri'
require 'dotenv'

Dotenv.load

SimpleCov.start do
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Models', 'app/models'
  add_group 'Models', 'app/services'
  add_group 'Libraries', 'lib'
  add_filter '/spec'
  add_filter '/config'
  add_filter '/app/admin'
end

ENV['RAILS_ENV'] ||= 'test'
ENV['http_proxy'] = ''

require File.expand_path('../../config/environment', __FILE__)
require 'reek'
require 'reek/spec'
require 'rspec/rails'
require 'rspec-sidekiq'
require 'shoulda-matchers'
require 'webmock/rspec'
require 'pundit/rspec'
require 'byebug'

require 'rack/utils'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods

  config.filter_run_excluding integration: true
  config.filter_run_excluding js: true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Disable rspec-rails' implicit wrapping of tests in a database transaction
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  def host(uri)
    uri = URI.parse(uri)
    "#{uri.hostname}:#{uri.port}"
  end

  config.before(:each) do
    WebMock.disable_net_connect!(
      allow: [
        host('http://codeclimate.com'),
        host(ENV.fetch('ELASTICSEARCH_URL'))
      ]
    )
    ActionMailer::Base.deliveries = []
  end

  config.before(:each, js: true) do
    ActionMailer::Base.deliveries = []
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    Sidekiq::Worker.clear_all
  end

  # Force the driver to wait till the page finishes loading
  config.after(:each, js: true) do
    current_path.should == current_path
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
