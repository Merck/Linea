# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
Raven.configure do |config|
  # filter our passwords from sending to sentry
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  # do NOT change this
  config.dsn = 'add your dsn config url'
  # no dev env
  config.environments = ['staging', 'uat', 'production']
  # send env as a tag
  config.tags = { environment: Rails.env, version: ENV.fetch('APPLICATION_VERSION') }
end
