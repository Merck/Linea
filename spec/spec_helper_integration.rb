# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'factory_girl_rails'
require 'uri'
require 'dotenv'

Dotenv.load '.env.test_integration'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'reek'
require 'reek/spec'
require 'rspec/rails'
require 'database_cleaner'
require 'shoulda-matchers'
require 'webmock/rspec'
require 'pundit/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

WebMock.allow_net_connect!(allow: 'http://localhost:9293')
WebMock.allow_net_connect!(allow: 'http://localhost:8888')

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
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

  # Clean up the Test Database
  # Before the entire test suite runs, clear the test database out completely
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, pre_count: true)
    WebMock.disable_net_connect!(allow: ['codeclimate.com'])
  end

  # Sets the default database cleaning strategy to be transactions === fast
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # Capybara tests run in a test server process so transactions won't work
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  # Standard config to run DatabaseCleaner
  config.before(:each) do
    DatabaseCleaner.start
    ActionMailer::Base.deliveries = []
  end

  # Force the driver to wait till the page finishes loading
  config.after(:each, js: true) do
    current_path.should == current_path
  end

  # Clean up after each execution
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

