# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module Searchable
  def self.included(base)
    base.class_eval do
      include Elasticsearch::Model
    end

    case base.name
    when 'Dataset'
      base.extend DatasetClassMethods

      base.class_eval do
        index_name "sampleDatabase_#{Rails.env}"

        after_commit -> { document_index }, on: :create
        after_commit -> { document_reindex }, on: :update
        after_commit -> { __elasticsearch__.delete_document }, on: :destroy

        settings analysis: index_analysis do
          mapping dynamic: 'true', _all: { enabled: 'false' } do
            indexes :name, type: 'multi_field' do
              indexes :name, type: 'string', analyzer: 'english'
              indexes :shingles, type: 'string', analyzer: 'custom_shingle_analyzer'
            end

            indexes :description, type: 'string', analyzer: 'english'

            indexes(:subject_area) { indexes :id, index: :not_analyzed }
            indexes(:tags)         { indexes :id, index: :not_analyzed }
            indexes(:owner)        { indexes :id, index: :not_analyzed }
            indexes(:datasource)   { indexes :id, index: :not_analyzed }
            indexes :country_code, index: :not_analyzed
            indexes :country_name, type: 'string', analyzer: 'english'

            indexes :dataset_attributes do
              indexes :id, type: 'long', index: :not_analyzed
              indexes :key, type: 'string'
              indexes :value, type: 'string', analyzer: 'english'
              indexes :comment, type: 'string', analyzer: 'english'
            end

            with_options type: 'completion', payloads: true do
              indexes :name_autocomplete
              indexes :owner_full_name_autocomplete
              indexes :tag_autocomplete
            end
          end
        end

        # Implement with the fields we want to index
        def as_indexed_json(_option = {})
          as_json(
            include: owner_include,
            only: [:name, :description, :country_code, :created_at, :updated_at]
          ).merge(
            name_autocomplete: name_io,
            owner_full_name_autocomplete: owner_io,
            tag_autocomplete: tags.collect { |tag| tag_io(tag) },
            country_name: country_name
          )
        end

        private

        def owner_include
          {
            owner: { only: [:full_name, :id] },
            subject_area: { only: [:name, :id] },
            tags: { only: [:name, :id] },
            dataset_attributes: { only: [:id, :key, :value, :comment] },
            tables: { only: [:name] },
            columns: { only: [:name, :business_name] },
            # FIXME: A contributor record doesn't have "full_name" attribute
            # so "contributors" array in the output json will contain empty objects.
            contributors: { only: :full_name },
            datasource: { only: [:name, :id] }
          }
        end

        def name_io
          {
            input: [name].concat(name.to_s.split(' ')),
            output: name.downcase
          }
        end

        def owner_io
          return { input: '', output: '' } unless owner
          {
            input: [owner.full_name].concat(owner.full_name.to_s.split(' ')),
            output: owner.full_name.try(:downcase)
          }
        end

        def tag_io(tag)
          {
            input: [tag.name].concat(tag.name.split(' ')),
            output: tag.name.downcase
          }
        end
      end
    end
  end

  module DatasetClassMethods
    def create_search_index!(search_index: nil)
      Dataset.__elasticsearch__.create_index! index: search_index
    end

    def create_test_search_index!
      create_search_index! search_index: 'sampleDatabase_test'
    end

    def index_analysis
      {
        "filter" => {
          "bigrams_filter" => {
            "type" => "shingle",
            "min_shingle_size" => 2,
            "max_shingle_size" => 2,
            "output_unigrams" => false
          }
        },
        "analyzer" => {
          "custom_shingle_analyzer" => {
            "type" => "custom",
            "tokenizer" => "standard",
            "filter" => [
              "lowercase",
              "bigrams_filter"
            ]
          }
        }
      }
    end
  end
end
