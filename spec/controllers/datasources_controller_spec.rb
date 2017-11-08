# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe DatasourcesController, type: :controller  do
  before do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe 'GET index' do
    it 'renders all the datasources' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'renders single datasource instance' do
      datasource = create(:datasource)

      get :show, id: datasource.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new datasource' do
      post :create, datasource: { name: 'test' }

      datasource = Datasource.last

      expect(datasource.name).to eq('test')
      expect(response.status).to eq(302)
      expect(response).to redirect_to(datasource_path(datasource.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of datasource' do
      datasource = create(:datasource)

      put :update, id: datasource.id, datasource: { name: 'new name' }

      datasource = Datasource.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(datasource_path(datasource.id))
      expect(datasource.name).to eq('new name')
    end

    it 'redirects away when no datasource id is given' do
      put :update, id: 'nonsense id', datasource: { name: 'new name' }

      expect(response).to redirect_to(datasources_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of datasource' do
      datasource = create(:datasource)

      delete :destroy, id: datasource.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(datasources_path)
      expect(Datasource.all.size).to eq(0)
    end
  end
end
