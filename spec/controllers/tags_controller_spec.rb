# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe TagsController, type: :controller  do
  before do
    @user = create(:user, is_admin: true)
    session[:user_id] = @user.id
  end

  describe 'GET index' do
    it 'renders all the tags' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'renders single tag instance' do
      tag = create(:tag)

      get :show, id: tag.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new tag' do
      post :create, tag: { name: 'test' }

      tag = Tag.last

      expect(tag.name).to eq('test')
      expect(response.status).to eq(302)
      expect(response).to redirect_to(tag_path(tag.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of tag' do
      tag = create(:tag)

      put :update, id: tag.id, tag: { name: 'new name' }

      tag = Tag.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(tag_path(tag.id))
      expect(tag.name).to eq('new name')
    end

    it 'redirects away when no tag id is given' do
      put :update, id: 'nonsense id', tag: { name: 'new name' }

      expect(response).to redirect_to(tags_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of tag' do
      tag = create(:tag)

      delete :destroy, id: tag.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(tags_path)
      expect(Tag.all.size).to eq(0)
    end
  end

  describe 'Popular' do
    it 'returns the most popular tags' do
      dataset = create(:dataset)
      tag = create(:tag, name: 'health')
      create(:dataset_tag, dataset: dataset, tag: tag)

      dataset = create(:dataset)
      tag = create(:tag, name: 'Linea')
      create(:dataset_tag, dataset: dataset, tag: tag)

      get :popular
      expect(response_json.size).to eq(2)
    end
  end

  describe 'Autocomplete' do
    it 'returns the correct autocompletes for given query' do
      stub_elastic_search

      Dataset.create_test_search_index!
      dataset = create(:dataset)
      tag = create(:tag, name: 'health')
      create(:dataset_tag, dataset: dataset, tag: tag)

      get :autocomplete, q: 'he'
      expect(response_json).not_to be_empty
      expect(response_json[0]).to eq('health')
    end
  end

  def stub_elastic_search
    stub_headers
    stub_request(:post, 'http://localhost:9200/sampleDatabase_test/_suggest')
      .with(body: "{\"tag\":{\"text\":\"he\",\"completion\":{\"field\":\"tag_autocomplete\"}}}",
            headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                       'User-Agent' => faraday_version })
      .to_return(status: 200,
                 body: { '_shards' => { 'total' => 5, 'successful' => 5, 'failed' => 0 },
                         'tag' => [{ 'text' => 'he', 'offset' => 0, 'length' => 2, 'options' => [{
                           'text' => 'health', 'score' => 1.0 }] }] }.to_json,
                 headers: { content_type: 'application/json; charset=UTF-8' })
  end

  def stub_headers
    stub_request(:head, 'http://localhost:9200/sampleDatabase_test')
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => faraday_version })
      .to_return(status: 200, body: '', headers: {})
  end
end
