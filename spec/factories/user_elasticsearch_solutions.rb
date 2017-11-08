# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'securerandom'

FactoryGirl.define do
  factory :user_elasticsearch_solution do
    association :user_solution, factory: :user_solution
    ip_address { Faker::Internet.ip_v4_address }
    index_name { Faker::Lorem.words(3) }
    external_id { "wf_user_elasticsearch_solution_#{SecureRandom.hex}" }
    host { Faker::Internet.domain_name }
    port { 9000 }
    datasets {[FactoryGirl.create(:dataset)]}
  end
end
