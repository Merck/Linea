# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require File.expand_path('../boot', __FILE__)
require 'rails/all'
require 'elasticsearch/rails/instrumentation'
require_relative '../lib/middleware/catch_json_parse_error'

Bundler.require(*Rails.groups)

Dotenv::Railtie.load

Dotenv.load(".env.#{ENV['RAILS_ENV']}")

module sampleDatabase
  class Application < Rails::Application

    config.middleware.insert_before ActionDispatch::ParamsParser, "CatchJsonParseErrors"
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    %w(models services queries).each do |path|
      config.autoload_paths += Dir[Rails.root.join('app', path, '{**}')]
    end
    config.autoload_paths << Rails.root.join('lib')

    config.active_record.raise_in_transactional_callbacks = true
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      "<span class='field_with_errors'>#{html_tag}</span>".html_safe
    end
    config.support_email = "support@support.company.com"
  end
end
