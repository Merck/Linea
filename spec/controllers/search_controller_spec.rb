# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe SearchController, type: :controller  do
  let(:user) { create :admin_user }

  before do
    session[:user_id] = user.id
  end

  describe 'request for terms of use' do
    let!(:terms_of_use) { create :terms_of_use }
    before { get :search }
    it 'is expected to redirect to terms of use acceptance' do
      expect(response).to redirect_to(accept_terms_of_use_path)
    end
  end

  describe 'search' do
    it 'perfoms the search' do
      payload = {
        "query":{
          "filtered":{
            "filter":{},
            "query":{
              "dis_max":{
                "tie_breaker":0.3,
                "queries":[
                  {
                    "bool":{
                      "should":{
                        "match_phrase":{
                          "name":{
                            "query":"registry",
                            "slop":50
                          }
                        }
                      },
                    "boost":10,
                    "minimum_should_match":"50%"
                    }
                  },
                  {
                    "match_phrase":{
                      "description":{
                        "query":"registry",
                        "slop":50,
                        "boost":2
                      }
                    }
                  },
                  {
                    "match_phrase":{
                      "owner.full_name":{
                        "query":"registry",
                        "slop":50,
                        "boost":2
                      }
                    }
                  },
                  {
                    "match_phrase":{
                      "subject_area.name":{
                        "query":"registry",
                        "slop":50,
                        "boost":1
                      }
                    }
                  },
                  {
                    "match_phrase":{
                      "country_code":{
                        "query":"registry",
                        "slop":50,
                        "boost":1
                      }
                    }
                  },
                  {
                    "match_phrase":{
                      "datasources.name":{
                        "query":"registry",
                        "slop":50,
                        "boost":1
                      }
                    }
                  },
                  {
                    "match_phrase":{
                      "tags.name":{
                      "query":"registry",
                      "slop":50,
                      "boost":2
                    }
                  }
                },
                {
                  "match_phrase":{
                    "tables.name":{
                      "query":"registry",
                      "slop":50,
                      "boost":1
                    }
                  }
                },
                {
                  "match_phrase":{
                    "columns.name":{
                      "query":"registry",
                      "slop":50,
                      "boost":1
                    }
                  }
                },
                {
                  "match_phrase":{
                    "columns.business_name":{
                      "query":"registry",
                      "slop":50,
                      "boost":1
                    }
                  }
                }
              ]
            }
          }
        }
      },
      "highlight":{
        "pre_tags":["\u003cmark\u003e"],
        "post_tags":["\u003c/mark\u003e"],
        "fields":{
          "name":{},
          "description":{
            "number_of_fragments":0
          }
        }
      }
      }
      stub_search(payload)

      get :search, query: 'registry'

      expect(assigns(:total_results))
      expect(assigns(:datasets))
    end

    it 'perfoms the aggregations search' do
      payload = {"query":{"dis_max":{"tie_breaker":0.3,"queries":[{"bool":{"should":{"match_phrase":{"name":{"query":"registry","slop":50}}},"boost":"10","minimum_should_match":"50%"}},{"match_phrase":{"description":{"query":"registry","slop":50,"boost":"2"}}},{"match_phrase":{"owner.full_name":{"query":"registry","slop":50,"boost":"2"}}},{"match_phrase":{"subject_area.name":{"query":"registry","slop":50,"boost":1}}},{"match_phrase":{"country_code":{"query":"registry","slop":50,"boost":1}}},{"match_phrase":{"datasources.name":{"query":"registry","slop":50,"boost":1}}},{"match_phrase":{"tags.name":{"query":"registry","slop":50,"boost":"2"}}},{"match_phrase":{"tables.name":{"query":"registry","slop":50,"boost":1}}},{"match_phrase":{"columns.name":{"query":"registry","slop":50,"boost":1}}},{"match_phrase":{"columns.business_name":{"query":"registry","slop":50,"boost":1}}}]}},"aggs":{"tags":{"terms":{"field":"tags.id","size":0}},"subject_area":{"terms":{"field":"subject_area.id","size":0}},"owner":{"terms":{"field":"owner.id","size":0}}}}
      stub_search(payload)

      get :search, query: 'registry'

      expect(assigns(:tags))
      expect(assigns(:subject_areas))
      expect(assigns(:owners))
      expect(assigns(:countries))
    end
  end

  describe 'Autocomplete' do
    it 'returns the correct autocompletes for given query' do
      skip 'Pending due to refactoring as part of BDP-352'
      body_to_send = load_fixture('suggest_body_to_send.txt').strip
      stub_elasticsearch(action: 'suggest',
                         body: body_to_send,
                         response_to_receive: suggest_response_to_receive)

      dataset = create(:dataset)
      tag = create(:tag, name: 'health')
      create(:dataset_tag, dataset: dataset, tag: tag)
      Dataset.create_test_search_index!

      get :autocomplete, q: 'he'
      expect(response_json).not_to eq([])
      expect(response_json[0]).to eq('health')
    end
  end

  describe 'RelatedPeople' do
    it 'assigns the correct variables' do
      skip 'Pending due to refactoring as part of BDP-352'
      user = create(:user, full_name: 'Linea')

      body_to_send = load_fixture('related_people_body_to_send.txt').strip
      response_to_receive = related_people_response_to_receive(user.id)
      stub_elasticsearch(action: 'search',
                         body: body_to_send,
                         response_to_receive: response_to_receive)
      Dataset.create_test_search_index!
      create(:dataset, name: 'Linea', owner_id: user.id)
      get :related_people, query: 'Linea'

      expect(assigns(:total_results)).to eq(1)
      expect(assigns(:tags)).to eq([{ text: 'Linea', size: 20 }])
    end
  end

  describe 'RelatedTags' do
    it 'assigns the correct variables' do
      skip 'Pending due to refactoring as part of BDP-352'
      tag = create(:tag, name: 'data')

      body_to_send = load_fixture('related_tags_body_to_send.txt').strip
      response_to_receive = related_tags_response_to_receive(tag.id)
      stub_elasticsearch(action: 'search',
                         body: body_to_send,
                         response_to_receive: response_to_receive)

      Dataset.create_test_search_index!
      dataset = create(:dataset, name: 'data')
      tag2 = create(:tag, name: 'data')

      create(:dataset_tag, dataset: dataset, tag: tag)
      create(:dataset_tag, dataset: dataset, tag: tag2)

      get :related_tags, query: 'data'

      expect(assigns(:total_results)).to eq(1)
      expect(assigns(:tags)).to eq([{ text: 'data', size: 20 }])
    end
  end

  private

  def stub_elasticsearch(options = {})
    action = options.fetch(:action)
    body = options.fetch(:body)
    response_to_receive = options.fetch(:response_to_receive)
    params = options.fetch(:params, '')
    stub_elastic_headers
    stub_request(request_method(action), request_url(action, params))
      .with(body: body,
            headers: { 'Accept' => '*/*',
                       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                       'User-Agent' => faraday_version })
      .to_return(status: 200, body: response_to_receive, headers: {})
  end

  def stub_search(body_to_send)
    stub_elasticsearch(action: 'search',
                       body: body_to_send,
                       response_to_receive: '',
                       params: '?from=0&size=5')
  end

  def url_mapping(params = nil)
    { 'search' => ['get', "http://localhost:9200/sampleDatabase_test/dataset/_search#{params}"],
      'suggest' => ['post', 'http://localhost:9200/sampleDatabase_test/_suggest'] }
  end

  def request_method(action)
    url_mapping.fetch(action)[0].to_sym
  end

  def request_url(action, params = nil)
    url_mapping(params).fetch(action)[1]
  end

  def stub_elastic_headers
    stub_request(:head, 'http://localhost:9200/sampleDatabase_test')
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => faraday_version })
      .to_return(status: 200, body: '', headers: {})
  end

  def suggest_response_to_receive
    {
      '_shards' => { 'total' => 5, 'successful' => 5, 'failed' => 0 },
      'owner_name' => [
        { 'text' => 'he', 'offset' => 0, 'length' => 2, 'options' => [] }
      ],
      'name' => [
        { 'text' => 'he', 'offset' => 0, 'length' => 2, 'options' => [] }
      ],
      'tag' => [
        { 'text' => 'he', 'offset' => 0, 'length' => 2, 'options' => [
          { 'text' => 'health', 'score' => 1.0 }
        ] }
      ]
    }
  end

  def related_people_response_to_receive(user_id)
    { 'took' => 2, 'timed_out' => false,
      '_shards' => { 'total' => 5, 'successful' => 5, 'failed' => 0 },
      'hits' => { 'total' => 1, 'max_score' => 1.0, 'hits' => [
        { '_index' => 'sampleDatabase_test', '_type' => 'dataset', '_id' => '9670', '_score' => 1.0,
          '_source' => {
            'name' => 'Linea', 'description' => 'Future-proofed directional leverage', 'country_code' => nil,
            'created_at' => '2015-04-29T13:39:08.426Z', 'updated_at' => '2015-04-29T13:39:08.426Z',
            'owner' => {
              'id' => 42_528, 'full_name' => 'Linea'
            },
            'tags' => [], 'dataset_visual_tools' => [], 'columns' => [], 'contributors' => [],
            'name_autocomplete' => {
              'input' => %w(Linea Linea), 'output' => 'Linea'
            },
            'owner_full_name_autocomplete' => {
              'input' => %w(Linea Linea), 'output' => 'Linea'
            },
            'tag_autocomplete' => []
          }
        }
      ] },
      'aggregations' => {
        'owner' => {
          'doc_count_error_upper_bound' => 0, 'sum_other_doc_count' => 0,
          'buckets' => [
            { 'key' => user_id, 'doc_count' => 1 }
          ]
        }
      }
    }
  end

  def related_tags_response_to_receive(tag_id)
    { 'took' => 2, 'timed_out' => false,
      '_shards' => { 'total' => 5, 'successful' => 5, 'failed' => 0 },
      'hits' => { 'total' => 1, 'max_score' => 1.0, 'hits' => [
      { '_index' => 'sampleDatabase_test', '_type' => 'dataset', '_id' => '11299', '_score' => 1.0,
        '_source' => {
          'name' => 'data', 'description' => 'Future-proofed attitude-oriented frame', 'country_code' => nil,
          'created_at' => '2015-04-30T14:30:25.605Z', 'updated_at' => '2015-04-30T14:30:25.605Z',
          'owner' => {
            'id' => 49_373, 'full_name' => 'Dawn Bogan DDS'
          },
          'tags' => [
            { 'id' => tag_id, 'name' => 'data' },
            { 'id' => tag_id, 'name' => 'data' }
          ],
          'dataset_visual_tools' => [], 'columns' => [], 'contributors' => [],
          'name_autocomplete' => { 'input' => %w(data data), 'output' => 'data' },
          'owner_full_name_autocomplete' => {
            'input' => ['Dawn Bogan DDS', 'Dawn', 'Bogan', 'DDS'],
            'output' => 'dawn bogan dds'
          },
          'tag_autocomplete' => [
            { 'input' => %w(data data), 'output' => 'data' },
            { 'input' => %w(data data), 'output' => 'data' }
          ]
        }
      }]
      },
      'aggregations' => {
        'tags' => { 'doc_count_error_upper_bound' => 0, 'sum_other_doc_count' => 0,
          'buckets' => [
            { 'key' => tag_id, 'doc_count' => 1 }
          ]
        }
      }
    }
  end

  def search_response_to_receive
    { '_index' => 'sampleDatabase_development',
      '_type' => 'dataset',
      '_id' => '26',
      '_score' => 0.36468005,
      '_source' => {
        'name' => 'Basic Stand Alone Skilled Nursing Facility Beneficiary PUF',
        'description' =>         'The CMS 2008 BSA SNF Beneficiary PUF originates from a 5% simple random sample of beneficiaries drawn (without replacement) from the 100% Beneficiary Summary File for reference year 2008. The sample that is used for the CMS 2008 BSA SNF Beneficiary PUF is disjoint from the existing 5% CMS research sample in the sense that there is no overlap in terms of the beneficiaries in the CMS 2008 BSA SNF Beneficiary PUF and the 5% CMS research sample.',
        'country_code' => 'GER',
        'created_at' => '2013-09-17T00:00:00.000Z',
        'updated_at' => '2015-05-04T16:30:50.269Z',
        'owner' => { 'id' => 63, 'full_name' => 'John Doe' },
        'subject_area' => { 'id' => 5, 'name' => 'R&D' },
        'tags' => [
          { 'id' => 47, 'name' => 'hospital compare' },
          { 'id' => 11, 'name' => 'medicare' },
          { 'id' => 17, 'name' => 'nursing home' }
        ],
        'dataset_attributes' => [ {'id' => '1', 'key' => 'Attribute 1', 'value' => 'Value 1', 'comment' => 'comment'} ],
        'columns' => [
          { 'business_name' => 'Benefit ID' },
          { 'business_name' => 'Sex ID' },
          { 'business_name' => 'Age' },
          { 'business_name' => 'Amount average' },
          { 'business_name' => 'Rehab days' },
          { 'business_name' => 'Restructure days' },
          { 'business_name' => 'Payment Amount' }
        ],
        'contributors' => [],
        'datasource' => { 'id' => 2, 'name' => 'SAP' },
        'name_autocomplete' => {
          'input' => ['Basic Stand Alone Skilled Nursing Facility Beneficiary PUF',
                      'Basic',
                      'Stand',
                      'Alone',
                      'Skilled',
                      'Nursing',
                      'Facility',
                      'Beneficiary',
                      'PUF'
                    ],
          'output' => 'basic stand alone skilled nursing facility beneficiary puf'
        },
        'owner_full_name_autocomplete' => { 'input' => ['John Doe', 'John', 'Doe'], 'output' => 'John Doe' },
        'tag_autocomplete' => [
          { 'input' => ['hospital compare', 'hospital', 'compare'], 'output' => 'hospital compare' },
          { 'input' => %w(medicare medicare), 'output' => 'medicare' },
          { 'input' => ['nursing home', 'nursing', 'home'], 'output' => 'nursing home' }
        ]
      }
    }
  end
end
