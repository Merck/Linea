# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module Api
  module V1
    class DatasetResource < JSONAPI::Resource
      attributes :name, :description, :country_code, :domain, :restricted, :created_at, :tags
      attributes :ingested, :external_id

      has_one :terms_of_service
      has_one :subject_area
      has_one :owner, class: 'User'
      has_one :datasource
      has_many :dataset_attributes
      has_many :notes
      #has_many :tags
      has_many :tables

      def meta(options)
        {
          country: {
            code: @model.country_code,
            name: @model.country_name
          },
          counts: {
            attributes: @model.dataset_attributes.count,
            notes: @model.notes.count
          }
        }
      end

      def tags
        @model.tags.select([:id, :name])
      end

      def tags=(new_tags)
        @model.tags.destroy_all
        dataset_tags = Tag.proceed_tags(new_tags)
        @model.tag_ids = dataset_tags
      end

      paginator :offset

      filter :external_id
      filter :datasource
      filter :domain
    end
  end
end
