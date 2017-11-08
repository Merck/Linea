# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe AutocompleteSearchQuery do
  it 'returns all the results when given only where', elasticsearch: true do
    stub_elastic_search
    instance = AutocompleteSearchQuery.new('he')
    expect(instance.where(['tag']).to_a).to eq([{ 'text' => 'health', 'score' => 1.0 }])
  end

  it 'returns only texts when given collect', elasticsearch: true do
    stub_elastic_search
    instance = AutocompleteSearchQuery.new('he')
    expect(instance.where(['tag']).collect('text').to_a).to eq(['health'])
  end

  it 'returns sorted results when given sort', elasticsearch: true do
    multiple_stub_elastic_search
    instance = AutocompleteSearchQuery.new('he')
    expect(instance.where(['tag']).collect('text').sort_by('score').to_a).to eq(%w(heal health))
  end

  def stub_elastic_search
    stub_headers

    stub_request(:post, 'http://localhost:9200/sampleDatabase_test/_suggest')
      .with(body: "{\"tag\":{\"text\":\"he\",\"completion\":{\"field\":\"tag_autocomplete\"}}}",
            headers: { 'Accept' => '*/*',
                       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                       'User-Agent' => faraday_version })
      .to_return(status: 200,
                 body: simple_body.to_json, headers: { content_type: 'application/json; charset=UTF-8' })
  end

  def multiple_stub_elastic_search
    stub_headers

    stub_request(:post, 'http://localhost:9200/sampleDatabase_test/_suggest')
      .with(body: "{\"tag\":{\"text\":\"he\",\"completion\":{\"field\":\"tag_autocomplete\"}}}",
            headers: { 'Accept' => '*/*',
                       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                       'User-Agent' => faraday_version })
      .to_return(status: 200, body: multi_body.to_json,  headers: { content_type: 'application/json; charset=UTF-8' })
  end

  def stub_headers
    stub_request(:head, 'http://localhost:9200/sampleDatabase_test')
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => faraday_version })
      .to_return(status: 200, body: '', headers: {})
  end

  def simple_body
    {
      '_shards' => { 'total' => 5, 'successful' => 5, 'failed' => 0 },
      'tag' => [{ 'text' => 'he', 'offset' => 0, 'length' => 2,
                  'options' => [{ 'text' => 'health', 'score' => 1.0 }] }]
    }
  end

  def multi_body
    {
      '_shards' => { 'total' => 5, 'successful' => 5, 'failed' => 0 },
      'tag' => [{ 'text' => 'he', 'offset' => 0, 'length' => 2,
                  'options' => [{ 'text' => 'health', 'score' => 1.0 },
                                { 'text' => 'heal', 'score' => 6.0 }] }]
    }
  end
end
