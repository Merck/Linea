# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
#require 'Linea_utilities'
require 'rest/client_error'
module Rest
  class Client
    attr_reader :hostname, :scheme, :port, :request_headers,
                :credentials, :last_response_code, :data_type

    def initialize(root_url:, credentials:, headers: {}, data_type: 'json', http_options: {})
      @credentials = credentials
      @root_uri = self.class.parse_uri(root_url)
      @scheme = @root_uri.scheme
      @port = @root_uri.port
      @hostname = @root_uri.hostname
      @request_headers = headers
      @data_type = data_type
      @http_options = http_options
    end

    def get(url)
      client = build_client(url)
      data = client.get
      handle_response(url, client)
      if request?('json')
        JSON.parse(data)
      else
        data
      end
    end

    def post(url, payload)
      client = build_client(url, payload)
      data = client.send
      handle_response(url, client)
      data
    end

    def put(url, payload)
      client = build_client(url, payload)
      data = client.put
      handle_response(url, client)
      data
    end

    def delete(url)
      client = build_client(url)
      data = client.delete
      handle_response(url, client)
      data
    end

    def self.parse_uri(uri)
      LineaUtilities::Components::Endpoint.uri(uri.dup)
    end

    def self.empty_credentials
      LineaUtilities::Components::Credentials.new(
        username: :not_needed,
        password: :not_needed
      )
    end

    private

    def protocol
      "#{scheme}://"
    end

    def handle_response(url, client)
      @last_response_code = client.response_code
      unless client.success?
        full_url = "#{@root_uri}#{url}"
        Rails.logger.error("Rest client error: #{@last_response_code}, response: #{client.response}")
        fail ClientError.new url: full_url, response: client.response, response_code: @last_response_code
      end
    end

    def build_client(url, payload = nil)
      LineaUtilities::Components::RestClient.new(
        restclient_options(url).merge(
          payload_options(payload)
        )
      )
    end

    def restclient_options(url)
      endpoint = endpoint_from_url(url)
      @restclient_options ||= {
        debug: ENV.fetch('DEBUG_HTTP', false) == 'true',
        endpoint: endpoint,
        credentials: credentials,
        headers: request_headers,
        http_options: @http_options
      }
    end

    def payload_options(payload)
      if request?('json')
        { payload: payload.to_json }
      elsif payload.blank? == false
        { parameters: payload }
      else
        { }
      end
    end

    def request?(type)
      data_type == type
    end

    def endpoint_from_url(url)
      is_ssl = scheme == 'https'
      LineaUtilities::Components::Endpoint.new(hostname: @hostname, path: url, port: port, ssl: is_ssl)
    end
  end
end
