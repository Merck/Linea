# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'json'

module AuthenticationService
  class AuthenticationError < StandardError; end
  class ApiKeyIsNotDefinedError < AuthenticationError; end
  class InvalidApiKeyError < AuthenticationError; end
  class UnknownError < AuthenticationError; end

  class << self
    def authenticated_user(username, password)
      result_json = perform_authenticate_http_call(username, password)

      unless result_json['user']
        handle_authenticate_error(username, result_json['error'])
        return nil
      end

      result = get_profile(username)
      if result.profile
        user = User.find_or_create_user_from_iam_profile_by_username(username, result)
        user.update_column(:last_login, Time.now)
        user
      end
    end

    def get_profile(username)
      #auri = URI.join(iam_uri + '/api/v2/profile/', username)
      #uri.query = URI.encode_www_form(isid: username, api_key: api_key)
      #response = Net::HTTP.get_response(uri)
      json = '{
        "profile": {
        "address": "123 Main Street",
        "country": "United States",
        "country_code": "US",
        "department": "UX",
        "email": "first.last@Linea.com",
        "full_name": "First Last",
        "first_name": "First",
        "isid": ":username:",
        "last_name": "Last",
        "location": "Rahway",
        "manager": "Last, First",
        "region": "NA",
        "state": "New Jersey",
        "title": "President",
        "postal_code": "12345-1234",
        "phone": "555-555-5555"
        }
      }'.gsub(/:username:/, username)
      JSON.parse(json, object_class: OpenStruct)
    end

    private

    def iam_uri
      ENV.fetch('IAM_URI')
    end

    def perform_authenticate_http_call(username, password)
      #response = Net::HTTP.post_form(
      #  URI(iam_uri + '/api/v2/authentication'),
      #  username: username,
      #  password: password,
      #  api_key: api_key
      #)
      json = '{"user":{"country_code":"US","email":"blabla@Linea.com","first_name":"US","groups":["Group 1","Group 2"],"last_name":"User","name":"US User"}}'
      JSON.parse(json)
    end

    def handle_authenticate_error(username, error_str)
      case error_str
      when 'Invalid api_key'
        Rails.logger.fatal('AuthenticationService: IAM_API_KEY is invalid.')
        fail InvalidApiKeyError

      when 'Invalid username or password'
        Rails.logger.info("Authentication failure. Username: \"#{username}\", error: #{error_str}")

      else
        Rails.logger.fatal("AuthenticationService: unknown authentication error. Error: #{error_str}")
        fail UnknownError
      end
    end

    def api_key
      ENV.fetch('IAM_API_KEY') { fail ApiKeyIsNotDefinedError }
    end
  end
end
