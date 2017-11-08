# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe SessionsController, type: :controller do
  describe 'login_attempt' do
    let(:username) { 'johndoe' }
    let(:password) { 'company123' }
    let!(:user) { create :user }

    before do
      allow(AuthenticationService).to receive(:authenticated_user).with(username, password).and_return(user)
    end

    context 'empty username or password' do
      before do
        post :login_attempt, username: '', password: password
      end
      xit 'expect flash message' do
        expect(flash[:warning]).to eq 'Missing username and/or password'
      end
      xit 'redirects user to the login path' do
        expect(response).to redirect_to(log_in_path)
      end
    end

    context 'wrong username or password' do
      before do
        allow(AuthenticationService).to receive(:authenticated_user).with('wrong', 'password').and_return(nil)
        post :login_attempt, username: 'wrong', password: 'password'
      end
      xit 'redirects user to the login path' do
        expect(response).to redirect_to(log_in_path)
      end
    end

    context 'when the redirect_back_url value is not set' do
      before do
        post :login_attempt, username: username, password: password
      end

      xit { expect(session[:user_id]).to eq user.id }
      xit 'redirects user to the root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the redirect_back_url value is set' do
      before do
        session[:return_to] = search_path
        post :login_attempt, username: username, password: password
      end

      xit { expect(session[:user_id]).to eq user.id }
      xit 'redirects user to the root path' do
        expect(response).to redirect_to(search_path)
      end
    end
  end
end
