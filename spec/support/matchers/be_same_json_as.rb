# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
# Allows to check if json as a string matches to a hash.
#
# Example:
#
# expect(%|{"one":1,"two":2}|).to be_same_json_as("one" => 1, "two" => 2)

RSpec::Matchers.define :be_same_json_as do |expected_hash|
  match do |actual_json_str|
    actual_hash = JSON.parse(actual_json_str)
    actual_hash == expected_hash
  end
end
