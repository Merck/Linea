# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

RSpec.describe Api::V1::SessionsController do
  let!(:user) { create :user }
  let!(:apiuser) { create :api_user, user_id: user.id }
  let(:password) { 'samplepassword' }

  before(:each) { set_api_headers }

  context 'valid user' do
    before do
      allow(AuthenticationService).to receive(:authenticated_user).with(user.username, password).and_return(user)
      post :create, { username: user.username, password: password }
    end

    it { is_expected.to respond_with :ok }
    it { expect(response.body).to eq({api_key: apiuser.reload.api_key}.to_json) }
  end

  context 'valid authentication always change api key' do
    before do
      allow(AuthenticationService).to receive(:authenticated_user).with(user.username, password).and_return(user)
      post :create, { username: user.username, password: password }
      @response1 = apiuser.reload.api_key
      post :create, { username: user.username, password: password }
      @response2 = apiuser.reload.api_key
    end

    it { is_expected.to respond_with :ok }
    it { expect(@response1).not_to eq(@response2) }
  end

  context 'invalid user' do
    before do
      allow(AuthenticationService).to receive(:authenticated_user).with(user.username, password).and_return(nil)
      post :create, { username: user.username, password: password }
    end

    it { is_expected.to respond_with :unauthorized }
  end
end
