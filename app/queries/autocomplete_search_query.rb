# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class AutocompleteSearchQuery
  include SearchStringBuildable

  def initialize(query, model = nil)
    @query = query
    @model = model
  end

  def to_a
    if @sorted_by
      sorted_suggested_results.map { |item| item.fetch(collected, item) }
    else
      suggest_results.map { |item| item.fetch(collected, item) }
    end
  end

  def each
    sorted_suggested_results.each do |item|
      yield(item)
    end
  end

  private

  attr_accessor :model, :query, :nodes, :sorted_by, :selected_fields, :collected, :fields_mapping

  def sorted_suggested_results
    @sorted_suggested_results ||= suggest_results.sort do |item1, item2|
      item2[@sorted_by] <=> item1[@sorted_by]
    end
  end

  def suggest_results
    @suggest_results ||= selected_fields.flat_map do |item|
      if (found_items = client_suggest[item])
        found_items.first['options']
      end
    end
  end

  def client_suggest
    client.suggest(
      index: Dataset.index_name,
      body: where_statement
    )
  end

  def fields_mapping
    { name: 'name_autocomplete', owner_name: 'owner_full_name_autocomplete', tag: 'tag_autocomplete' }
  end
end
