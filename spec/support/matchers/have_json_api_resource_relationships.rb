# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class HaveJsonApiResourceRelationships
  def initialize(relationships, options = {})
    @relationships = relationships
    @options = options.fetch(:match, :include)
  end

  def matches?(json_response)
    @json_response = JSON.parse(json_response)
    @json_response['data'].is_a?(Hash) && matches_relationships?
  end

  def failure_message
    "Expected JSON API resources to have `#{@relationships}` relationships, but has `#{@json_response['data']['relationships'].keys}`" +
    " diff #{@json_response['data']['relationships'].keys - @relationships}, match `#{@options.inspect}`"
  end

  def failure_message_when_negated
    "Expected JSON API resources not to be `#{@resource_name}` type"
  end

  private

  def matches_relationships?
    return false unless @json_response['data']['relationships'].is_a?(Hash)
    @relationships = Array.wrap(@relationships)
    return @json_response['data']['relationships'].keys & @relationships == @relationships if @options == :include
    @json_response['data']['relationships'].keys == @relationships if @options == :exact
  end
end

def have_json_api_resource_relationships(relationships, options = {})
  HaveJsonApiResourceRelationships.new(relationships, options)
end
