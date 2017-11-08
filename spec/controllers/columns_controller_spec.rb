# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe ColumnsController, type: :controller  do
  before do
    @user = create(:user, is_admin: true)
    admin = create(:user, is_admin: true, username: 'shosanna')
    session[:user_id] = admin.id
  end

  describe 'GET index' do
    it 'renders all the columns' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'renders single column instance' do
      column = create(:column)

      get :show, id: column.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new column' do
      post :create, column: { name: 'test', data_type: 'string' }

      column = Column.last

      expect(column.name).to eq('test')
      expect(response.status).to eq(302)
      expect(response).to redirect_to(column_path(column.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of column' do
      column = create(:column)

      put :update, id: column.id, column: { name: 'new name' }

      column = Column.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(column_path(column.id))
      expect(column.name).to eq('new name')
    end

    it 'redirects away when no column id is given' do
      put :update, id: 'nonsense id', column: { name: 'new name' }

      expect(response).to redirect_to(columns_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of column' do
      column = create(:column)

      delete :destroy, id: column.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(columns_path)
      expect(Column.all.size).to eq(0)
    end
  end
end
