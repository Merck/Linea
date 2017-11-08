# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

RSpec.describe Api::V1::TagsController do
  let!(:user) { create :user }
  let!(:apiuser) { create :api_user, user_id: user.id }
  let!(:tags) { create_list :tag, 2 }

  before(:each) { set_api_headers(apiuser.api_key) }

  describe 'get all tags' do
    before { get :index }

    it { is_expected.to respond_with :ok }
    it { expect(response.body).to be_json_api_resources_for('tags') }
    it { expect(json_api_data.count).to eq(2) }
  end

  describe 'get all tags sorted by name' do
    before { get :index, sort: :name }

    it { is_expected.to respond_with :ok }
    it { expect(response.body).to be_json_api_resources_for('tags') }
    it { expect(json_api_data.first).to have_json_api_resource_attributes({ 'name' => tags.sort_by(&:name).first.name }) }
    it { expect(json_api_data.last).to have_json_api_resource_attributes({ 'name' => tags.sort_by(&:name).last.name }) }
  end

  describe 'get all tags filtered by name' do
    before { get :index, filter: { name: tags.first.name } }

    it { is_expected.to respond_with :ok }
    it { expect(response.body).to be_json_api_resources_for('tags') }
    it { expect(json_api_data.count).to eq(1) }
    it { expect(json_api_data.first).to have_json_api_resource_attributes({ 'name' => tags.first.name }) }
  end

  describe 'get no tags' do
    before { get :index, filter: { name: 'non existent tag' } }

    it { is_expected.to respond_with :ok }
    it { expect(response.body).to be_empty_json_api_response }
  end

  describe 'get single tag by id' do
    before { get :show, id: tags.first.id }

    it { is_expected.to respond_with :ok }
    it { expect(json_api_data).to have_json_api_resource_attributes({ 'name' => tags.first.name }) }
  end

  describe 'creating new tag' do
    context "with valid request" do
      let(:tag_request) { { data: { type: 'tags', attributes: { name: 'test tag' } } } }
      before { post :create, tag_request }

      it { is_expected.to respond_with 201 } # created
      it { expect(response.body).to be_json_api_resource_for('tags') }
      it { expect(json_api_data['id']).not_to be_empty }
      it { expect(json_api_data).to have_json_api_resource_attributes({ "name" => "test tag" }) }
    end

    context "with validation error" do
      let(:tag_request) { { data: { type: 'tags', attributes: { } } } }
      before { post :create, tag_request }

      it { is_expected.to respond_with :unprocessable_entity } # created
      it { expect(response.body).to be_error_json_api_response({
          "title" => "can't be blank",
          "detail" => "name - can't be blank",
          "source" => { "pointer" => "/data/attributes/name"} }) }
    end
  end

  describe 'creating multiple new tags' do
    let(:tags_request) { { data: [
                          { type: 'tags', attributes: { name: 'test tag' } },
                          { type: "tags", attributes: { name: 'test tag 2' } }
                        ] } }
    before { post :create, tags_request }

    it { is_expected.to respond_with 201 } # created
    it { expect(response.body).to be_json_api_resources_for('tags') }
    it { expect(json_api_data.count).to eq(2) }
    it { expect(json_api_data.first).to have_json_api_resource_attributes({ "name" => "test tag" }) }
    it { expect(json_api_data.last).to have_json_api_resource_attributes({ "name" => "test tag 2" }) }
  end

  describe 'removing a tag is forbidden' do
    before { delete :destroy, id: tags.first.id }
    it { is_expected.to respond_with :bad_request }
  end

  describe 'updating a tag is forbidden' do
    before { put :update, id: tags.first.id }
    it { is_expected.to respond_with :bad_request }
  end
end
