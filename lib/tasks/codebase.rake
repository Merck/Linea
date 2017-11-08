# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
namespace :namespaceToCheck do
  if %w(test development).include?(Rails.env)
    require 'rake_notifier'
    require 'reek/rake/task'
    require 'slim_lint/rake_task'
    require 'rubocop/rake_task'

    desc 'Run Rails Best Practices on the codebase'
    task :rbp do
      exec 'rails_best_practices'
    end

    desc 'Run security scanner on the codebase'
    task :security do
      exec 'brakeman --quiet --rails4'
    end

    namespace :quality do

      desc 'Check slim templates aka rubocop'
      SlimLint::RakeTask.new(:slim) do |t|
        t.files = ['app/views']
      end

      Reek::Rake::Task.new do |task|
        task.name = 'architecture'
        task.fail_on_error = false
        task.source_files = 'app/**/*.rb'
        task.verbose = true
      end

      desc 'Check the quality of the codebase'
      RuboCop::RakeTask.new(:ruby) do |task|
        task.fail_on_error = false
      end

      task default: :ruby
    end
  end
end
