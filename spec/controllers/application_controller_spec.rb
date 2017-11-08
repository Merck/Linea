# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      render nothing: true
    end
  end

  describe 'authenticate_user before filter' do
    context 'when the session user exists' do
      let(:user) { create(:user) }
      it 'assigns current_user' do

        get :index, {}, user_id: user.id

        expect(response).to have_http_status(:ok)
        expect(assigns(:current_user)).to eq(user)
      end
    end

    context 'when the session user doesnt exist' do
      context 'when its a get request' do
        it 'redirects to log_in path and sets redirect_back_url session value' do
          get :index, {}, { user_id: nil }

          expect(response).to redirect_to(log_in_path)
          expect(assigns(:current_user)).to be_nil
        end
      end

      context 'when its not a get request' do
        it 'redirects to log_in path and doesnt set redirect_back_url session value' do
          post :index, {}, { user_id: nil }

          expect(response).to redirect_to(log_in_path)
          expect(assigns(:current_user)).to be_nil
        end
      end
    end
  end
end
