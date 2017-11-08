# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class BeErrorJsonApiResponse
  def initialize(options = {})
    @options = options
  end

  def matches?(json_response)
    @json_response = JSON.parse(json_response)
    @json_response['errors'].is_a?(Array) && match_options
  end

  def failure_message
    return "Expected JSON API to be an error" if @options == {}
    return "Expected JSON API to be an error with `#{@options}` but got `#{@json_response['errors'].first}`"
  end

  def failure_message_when_negated
    return "Expected JSON API not to be an error" if @options == {}
    return "Expected JSON API not to be an error with `#{@options}` but got `#{@json_response['errors'].first}`"
  end

  private

  def match_options
    error_data = @json_response['errors'].first
    @options.each do |key, value|
      return false if error_data[key] != value
    end
    true
  end
end

def be_error_json_api_response(options = {})
  BeErrorJsonApiResponse.new(options)
end
