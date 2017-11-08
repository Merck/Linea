# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module Support
  module FeaturesHelper
    def stub_aim_request(http_method:, path:, request_body: {}, response_body:)
      stub_request(http_method, "url").with(
        body: request_body,
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host' => 'host url',
          'User-Agent' => 'Ruby'
        }
      ).to_return(status: 200, body: response_body, headers: {})
    end
  end
end

RSpec.configure do |config|
  config.include Support::FeaturesHelper
end
