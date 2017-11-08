# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
def login
    create(:user, username: 'someuser1')
    WebMock.disable_net_connect!(:allow_localhost => true)
    stub_aim_request(
      http_method: :get,
      path: "/profile/someuser1?api_key=#{ENV['AIM_API_KEY']}&isid=someuser1",
      response_body: {
        'profile' => {
          'assress' => '101 10th Street',
          'state' => 'NY',
          'postal_code' => '11215',
          'region' => 'Kings',
          'country' => 'USA',
          'country_code' => '1',
          'department' => 'R&D',
          'email' => 'someuser1@company.com',
          'full_name' => 'User One',
          'first_name' => 'User',
          'location' => '1st floor',
          'manager' => 'Richard Roe',
          'title' => 'Scientist'
        }
      }.to_json
    )

    stub_aim_request(
      http_method: :post,
      path: '/authentication',
      request_body: {
        'api_key' => ENV['AIM_API_KEY'],
        'password' => 'company1234',
        'username' => 'someuser1'
      },
      response_body: { user: true }.to_json
    )

    visit '/sessions/login'
    fill_in 'Username', with: 'someuser1'
    fill_in 'Password', with: 'company1234'
    click_button 'Sign In'
end
