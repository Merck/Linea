# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class BeJsonApiResourceFor
  def initialize(resource_name)
    @resource_name = resource_name
  end

  def matches?(json_response)
    @json_response = JSON.parse(json_response)
    @json_response['data'].is_a?(Hash) &&
      @json_response['data']['type'] == @resource_name &&
      @json_response['data']['attributes']
  end

  def failure_message
    "Expected JSON API resource to be `#{@resource_name}` type"
  end

  def failure_message_when_negated
    "Expected JSON API resource not to be `#{@resource_name}` type"
  end
end

def be_json_api_resource_for(resource)
  BeJsonApiResourceFor.new(resource)
end
