# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

RSpec.describe Api::V1::DatasetsController do
  let!(:user) { create :user }
  let!(:apiuser) { create :api_user, user_id: user.id }
  let!(:tags) { create_list :tag, 2 }
  let!(:datasets) { create_list :dataset, 2, country_code: 'US' }

  before(:each) { set_api_headers(apiuser.api_key) }

  describe 'get all datasets' do
    before { get :index }

    it { is_expected.to respond_with :ok }
    it { expect(response.body).to be_json_api_resources_for('datasets') }
    it { expect(json_api_data.count).to eq(2) }
    it 'has pagination links' do
      expect(json_api_pagination.keys).to eq(['first', 'last'])
    end

    context 'paginated' do
      before { get :index, page: { limit: 1, offset: 0 } }

      it { expect(json_api_data.count).to eq(1) }
      it 'has pagination links' do
        expect(json_api_pagination.keys).to eq(['first', 'next', 'last'])
      end
    end
  end

  describe 'get no dataset' do
    before { get :show, id: 0 }

    it { is_expected.to respond_with :not_found }
    it { expect(response.body).to be_error_json_api_response('title' => 'Record not found', 'code' => 404) }
  end

  describe 'get single dataset by id' do
    before { get :show, id: datasets.first.id }
    let(:dataset) { datasets.first }
    let(:attributes) { {
      'name' => dataset.name,
      'description' => dataset.description,
      'country-code' => dataset.country_code,
      'domain' => dataset.domain,
      'restricted' => dataset.restricted,
      'created-at' => dataset.created_at.iso8601(3),
      'tags' => dataset.tags.select([:id, :name]),
      'ingested' => dataset.ingested,
      'external-id' => dataset.external_id
    } }

    it { is_expected.to respond_with :ok }

    it 'has correct attributes' do
      expect(json_api_data).to have_json_api_resource_attributes(attributes)
    end

    it 'has correct relatinships' do
      expect(response.body).to have_json_api_resource_relationships(
        ['terms-of-service', 'subject-area', 'owner', 'datasource', 'dataset-attributes', 'notes', 'tables'],
        match: :exact)
    end

    it 'has link to self' do
      expect(json_api_data['links']).to eq({ 'self' => api_dataset_url(id: dataset.id) })
    end

    it 'has meta country info' do
      expect(json_api_data['meta']).to eq({
        'country' => { 'code' => dataset.country_code, 'name' => dataset.country_name} ,
        'counts' => { 'attributes' => 0, 'notes' => 0} }
      )
    end
  end

  describe 'get dataset with owner and subject-area' do
    before { get :show, id: datasets.first.id, 'include': 'owner,subject-area' }
    let(:dataset) { datasets.first }

    it { is_expected.to respond_with :ok }

    it 'has relationships included' do
      expect(response.body).to have_json_api_resource_includes(
        ['subject-areas', 'users'], match: :exact)
    end

    it 'has correct owner included' do
      expect(json_api_included('users').first['id']).to eq(dataset.owner.id.to_s)
    end

    it 'has correct user attributes included' do
      expect(json_api_included('users').first).to have_json_api_resource_attributes(
        { 'first-name' => dataset.owner.first_name, 'last-name' => dataset.owner.last_name })
    end

    it 'has correct subject area attributes' do
      expect(json_api_included('subject-areas').first).to have_json_api_resource_attributes(
      ['name', 'description'], match: :exact)
    end
  end

  describe 'dataset update' do
    let(:dataset) { datasets.first }
    let(:description) { dataset.description }

    context '- attributes, changes only name' do
      let(:payload) { { data: { type: 'datasets', id: dataset.id, attributes: { name: 'changed name' } } } }
      before { put :update, { id: dataset.id }.merge(payload) }
      it { is_expected.to respond_with :ok }
      it { expect(dataset.reload.name).to eq('changed name') }
      it { expect(dataset.reload.description).to eq(description) }
    end

    context 'tags' do
      let(:payload) { { data: { type: 'datasets', id: dataset.id, attributes: { tags: [tags.first.id, 'some tag'] } } } }
      before { put :update, { id: dataset.id }.merge(payload) }
      it { is_expected.to respond_with :ok }
      it { expect(dataset.reload.tags.count).to eq(2) }
      it { expect(dataset.reload.tags.map(&:name).sort).to eq([tags.first.name, 'some tag'].sort) }
    end
  end

  describe 'dataset removal' do
    context 'existing dataset' do
      let(:dataset) { datasets.first }
      before { delete :destroy, id: dataset.id }
      it { is_expected.to respond_with :no_content }
    end

    context 'nonexistent dataset' do
      before { delete :destroy, id: 1234 }
      it { is_expected.to respond_with :not_found }
    end

  end

end
