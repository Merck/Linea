# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module Api
  module V1
    class DatasetAttributeResource < JSONAPI::Resource
      attributes :key, :value, :comment, :created_at

      has_one :user, always_include_linkage_data: true
      has_one :dataset

      def self.updatable_fields(context)
        super - [:created_at, :updated_at]
      end

      def self.creatable_fields(context)
        super - [:created_at, :updated_at]
      end
    end
  end
end
