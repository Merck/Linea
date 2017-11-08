# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe AlgorithmsController, type: :controller  do
  before do
    @user = create(:user, is_admin: true)
    admin = create(:user, is_admin: true, username: 'shosanna')
    session[:user_id] = admin.id
  end

  describe 'GET index' do
    it 'renders all the algorithms' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'renders single algorithm instance' do
      algorithm = create(:algorithm)

      get :show, id: algorithm.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new algorithm' do
      post :create, algorithm: { name: 'test' }

      algorithm = Algorithm.last

      expect(algorithm.name).to eq('test')
      expect(response.status).to eq(302)
      expect(response).to redirect_to(algorithm_path(algorithm.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of algorithm' do
      algorithm = create(:algorithm)

      put :update, id: algorithm.id, algorithm: { name: 'new name' }

      algorithm = Algorithm.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(algorithm_path(algorithm.id))
      expect(algorithm.name).to eq('new name')
    end

    it 'redirects away when no algorithm id is given' do
      put :update, id: 'nonsense id', algorithm: { name: 'new name' }

      expect(response).to redirect_to(algorithms_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of algorithm' do
      algorithm = create(:algorithm)

      delete :destroy, id: algorithm.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(algorithms_path)
      expect(Algorithm.all.size).to eq(0)
    end
  end
end
