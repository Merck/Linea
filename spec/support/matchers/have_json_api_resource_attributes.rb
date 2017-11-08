# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class HaveJsonApiResourceAttributes
  def initialize(attributes, options = {})
    @attributes = attributes
    @options = options.fetch(:match, :include)
  end

  def matches?(data)
    @data = data
    json_attributes.is_a?(Hash) && matches_attributes
  end

  def matches_attributes
    return true if @attributes.is_a?(Hash) && json_attributes == @attributes
    return false unless @attributes.is_a?(Array)
    return json_attributes.keys & @attributes == @attributes if @options == :include
    json_attributes.keys == @attributes if @options == :exact
  end

  def failure_message
    "Expected JSON API resource attributes to be `#{@attributes}` but was `#{json_attributes}`"
  end

  def failure_message_when_negated
    "Expected JSON API resource attributes not to be `#{@attributes}`"
  end

  private

  def json_attributes
    @data['attributes']
  end
end

def have_json_api_resource_attributes(attributes, options = {})
  HaveJsonApiResourceAttributes.new(attributes, options)
end
