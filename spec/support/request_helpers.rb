# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module Support
  module RequestHelpers
    def response_json
      @json ||= JSON.parse(response.body)
    end

    def post_json(path, params)
      post path, params, 'HTTP_ACCEPT' => 'application/json'
    end
  end
end

RSpec.configure do |config|
  config.include Support::RequestHelpers, type: :controller
  config.include Support::RequestHelpers, type: :request
  config.include Support::RequestHelpers, type: :feature
end
