# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require_relative '../../spec_helper'
require 'rest/client'

xdescribe Rest::Client do
  context '#initialize' do
    it 'sets hostname' do
      rest_client = described_class.new root_url: 'http://example.com', credentials: described_class.empty_credentials
      expect(rest_client.hostname).to eq('example.com')
    end
  end

  context '#post' do
    let(:client) do
      described_class.new root_url: 'http://example.com', credentials: described_class.empty_credentials
    end

    it 'sends a post request' do
      WebMock.stub_request(:post, 'http://example.com/test')
        .to_return(status: 200, body: 'ok')
      http_response = client.post '/test', {}
      expect(http_response).to eq('ok')
    end

    it 'sends a post request as form-multipart request' do
      WebMock.stub_request(:post, 'http://example.com/test')
        .with(:body => anything(),
              :headers => {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-type' => 'application/x-www-form-urlencoded',
                'User-Agent'=>'Ruby'
              })
        .to_return(status: 200, body: 'ok')

      client = described_class.new(
        root_url: 'http://example.com',
        credentials: described_class.empty_credentials,
        data_type: 'form'
      )

      http_response = client.post(
        '/test',
        info: 'foo',
        data: load_fixture('me.jpg')
      )

      expect(http_response).to eq('ok')
    end

    it 'errorneous response raises exception' do
      expect(Rails.logger).to receive(:error).with(
        'Rest client error: 400, response: error body'
      )

      WebMock.stub_request(:post, 'http://example.com/test')
        .to_return(status: 400, body: 'error body')
      expect do
        client.post '/test', {}
      end.to raise_error do |error|
        expect(error).to be_a(Rest::ClientError)
        expect(error.message).to eq('Error occured while calling REST API. 400 - http://example.com/test')
        expect(error.response_code).to eq(400)
        expect(error.response).to eq('error body')
        expect(error.url).to eq('http://example.com/test')
      end
    end
  end
end