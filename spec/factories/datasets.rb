# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
FactoryGirl.define do
  factory :dataset do
    name { Faker::Lorem.word }
    ingested { false }
    terms_of_service_name {'N/A'}
    sequence :id do |id|
      id
    end

    description Faker::Company.catch_phrase
    association :owner, factory: :user
    association :datasource, factory: :datasource
    association :subject_area, factory: :subject_area
  end

  trait :with_table do
    after(:create) do |dataset|
      dataset.update_attribute(:jdbc_driver_id, 'org.postgresql.Driver')
      FactoryGirl.create_list(:table, 2, :with_columns, dataset: dataset)
    end
  end
end
