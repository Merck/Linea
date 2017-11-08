# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

RSpec.describe Api::V1::UsersController do
  let!(:apiuser) { create :api_user, user_id: user.id }
  let!(:user) { create :user }

  before(:each) { set_api_headers(apiuser.api_key) }

  describe 'get use detail' do
    before { get :show, id: user.id }

    it { is_expected.to respond_with :ok }
    it { expect(response.body).to be_json_api_resource_for('users') }
    it { expect(json_api_data).to have_json_api_resource_attributes(['first-name', 'last-name']) }
  end

  describe 'validate user' do
    before :each do
      allow(UserVerificationService).to receive(:verify_or_create).and_return(user)
    end

    context 'existing user' do
      before { post :verify, isid: user.username }

      it { is_expected.to respond_with :ok }
      it { expect(response.body).to be_json_api_resource_for('users') }
      it { expect(json_api_data).to have_json_api_resource_attributes(['first-name', 'last-name']) }
      it { expect(json_api_data['id']).to eq(user.id.to_s) }
    end

    context 'non-existing user' do
      before { post :verify, isid: 'somenewuser' }

      it { is_expected.to respond_with :ok }
      it { expect(response.body).to be_json_api_resource_for('users') }
      it { expect(json_api_data).to have_json_api_resource_attributes(['first-name', 'last-name']) }
    end

    context 'invalid user' do
      before do
        allow(UserVerificationService).to receive(:verify_or_create).and_raise(UserVerificationService::UserNotFound)
        post :verify, isid: 'somenewuser'
      end

      it { is_expected.to respond_with :not_found }
      it { expect(response.body).to be_error_json_api_response('title' => 'Record not found', 'code' => 404) }
    end
  end
end
