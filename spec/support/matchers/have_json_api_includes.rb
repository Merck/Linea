# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class HaveJsonApiResourceIncludes
  def initialize(includes, options = {})
    @includes = includes
    @options = options.fetch(:match, :include)
  end

  def matches?(json_response)
    @json_response = JSON.parse(json_response)
    included.is_a?(Array) && matches_includes?
  end

  def failure_message
    "Expected JSON API resources to have `#{@includes}` includes, but has `#{included_types}`" +
    " diff #{included_types - @includes}, match `#{@options.inspect}` #{included.class}"
  end

  def failure_message_when_negated
    "Expected JSON API resources not to include `#{@includes}`"
  end

  private

  def matches_includes?
    @includes = Array.wrap(@includes)
    return included_types & @includes == @includes if @options == :include
    included_types == @includes if @options == :exact
  end

  def included
    @json_response['included']
  end

  def included_types
    included.map{ |i| i['type'] }
  end
end

def have_json_api_resource_includes(includes, options = {})
  HaveJsonApiResourceIncludes.new(includes, options)
end
