# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module SearchStringBuildable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Enumerable

    def where(selected_fields)
      @selected_fields = selected_fields
      self
    end

    def sort_by(sorted_by)
      @sorted_by = sorted_by
      self
    end

    def collect(collected)
      @collected = collected
      self
    end

    private

    def where_statement
      @selected_fields.each_with_object({}) do |field, nodes|
        nodes[field] = {
          text: @query,
          completion: {
            field: mapping_for(field)
          }
        }
      end
    end

    def mapping_for(field)
      fields_mapping.fetch(field.to_sym)
    end

    def client
      if model
        "Elasticsearch::#{model}".constantize.client
      else
        Elasticsearch::Model.client
      end
    end
  end
end
