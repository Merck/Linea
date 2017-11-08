# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

RSpec.describe Api::V1::SubjectAreasController do
  let!(:user) { create :user }
  let!(:apiuser) { create :api_user, user_id: user.id }
  let!(:subject_areas) { create_list :subject_area, 2 }

  before(:each) { set_api_headers(apiuser.api_key) }

  describe 'get all subject areas' do
    before { get :index }

    it { is_expected.to respond_with :ok }
    it { expect(response.body).to be_json_api_resources_for('subject-areas') }
    it { expect(json_api_data.count).to eq(2) }
  end

  describe 'get no subject areas' do
    before { get :show, id: 0 }

    it { is_expected.to respond_with :not_found }
    it { expect(response.body).to be_error_json_api_response('title' => 'Record not found', 'code' => 404) }
  end

  describe 'get single subject area by id' do
    before { get :show, id: subject_areas.first.id }
    let(:attributes) { {
      'name' => subject_areas.first.name,
      'description' => subject_areas.first.description
    } }

    it { is_expected.to respond_with :ok }
    it { expect(json_api_data).to have_json_api_resource_attributes(attributes) }
  end

  describe 'removing a subject-area is forbidden' do
    before { delete :destroy, id: subject_areas.first.id }
    it { is_expected.to respond_with :bad_request }
  end

  describe 'updating a subject-area is forbidden' do
    before { put :update, id: subject_areas.first.id }
    it { is_expected.to respond_with :bad_request }
  end

  describe 'creating a subject-area is forbidden' do
    before { post :create }
    it { is_expected.to respond_with :bad_request }
  end
end
