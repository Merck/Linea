# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require File.expand_path('../config/application', __FILE__)
require 'rake_notifier'

Rails.application.load_tasks

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = "./spec/integration/**/*_spec.rb"
  end
  task rspec: [:integration]
rescue LoadError
  RakeNotifier.warn 'RuboCop not available, quality task not provided.'
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:features) do |t|
    t.rspec_opts = "--tag js"
    t.pattern = "./spec/features/**/*_spec.rb"
  end
  task rspec: [:features]
rescue LoadError
  RakeNotifier.warn 'RuboCop not available, quality task not provided.'
end
