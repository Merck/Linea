# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module Support
  module AuthHelpers
    def logged_in(profile: {
      'assress' => '101 10th Street',
      'state' => 'NY',
      'postal_code' => '11215',
      'region' => 'Kings',
      'country' => 'USA',
      'country_code' => '1',
      'department' => 'R&D',
      'email' => 'johndoe@company.com',
      'full_name' => 'John Doe',
      'first_name' => 'John',
      'location' => '1st floor',
      'manager' => 'Richard Roe',
      'title' => 'Scientist'
      })

      stub_aim_request(
        http_method: :get,
        path: "/profile/johndoe?api_key=#{ENV['AIM_API_KEY']}&isid=johndoe",
        response_body: {'profile' => profile}.to_json
      )

      stub_aim_request(
        http_method: :post,
        path: '/authentication',
        request_body: {
          'api_key' => ENV['AIM_API_KEY'],
          'password' => 'company1234',
          'username' => 'johndoe'
        },
        response_body: { user: true }.to_json
      )

      visit '/sessions/login'
      fill_in 'Username', with: 'johndoe'
      fill_in 'Password', with: 'company1234'
      click_button 'Login'
    end

    def stub_aim_request(http_method:, path:, request_body: {}, response_body:)
      stub_request(http_method, "url").with(
        body: request_body,
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host' => 'iam.it.company.com',
          'User-Agent' => 'Ruby'
        }
      ).to_return(status: 200, body: response_body, headers: {})
    end
  end
end

RSpec.configure do |config|
  config.include Support::AuthHelpers
end
