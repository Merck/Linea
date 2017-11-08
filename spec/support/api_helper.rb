# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
def set_api_headers(api_key = nil)
  request.headers['Accept'] = 'application/vnd.api+json; version=1'
  request.headers['Content-Type'] = 'application/vnd.api+json'
  request.headers['Authorization'] = api_key if api_key
end

def json_api_data
  parsed_data = JSON.parse(response.body)
  parsed_data['data']
end

def json_api_data_meta
  parsed_data = JSON.parse(response.body)
  parsed_data['data']['meta']
end

def json_api_pagination
  parsed_data = JSON.parse(response.body)
  parsed_data['links']
end

def json_api_included(filter = [])
  parsed_data = JSON.parse(response.body)
  included = parsed_data['included']
  filter = Array.wrap(filter)
  return included if filter.empty?
  included.select{ |i| filter.include?(i['type']) }
end

def json_api_errors
  parsed_data = JSON.parse(response.body)
  parsed_data['errors']
end



