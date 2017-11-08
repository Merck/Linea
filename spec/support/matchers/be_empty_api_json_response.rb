# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class BeEmptyJsonApiResponse
  def initialize
  end

  def matches?(json_response)
    @json_response = JSON.parse(json_response)
    @json_response['data'].is_a?(Array) && @json_response['data'] == []
  end

  def failure_message
    "Expected JSON API response to be empty"
  end

  def failure_message_when_negated
    "Expected JSON API response not to be empty"
  end
end

def be_empty_json_api_response
  BeEmptyJsonApiResponse.new
end
