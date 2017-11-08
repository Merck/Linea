# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe SearchActivitiesController, type: :controller  do
  before do
    @user = create(:user, is_admin: true)
    session[:user_id] = @user.id
  end

  describe 'GET index' do
    it 'renders all the search activity' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'renders single search activity instance' do
      search_activity = create(:search_activity)

      get :show, id: search_activity.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new search activity' do
      post :create, search_activity: { search_terms: 'test' }

      search_activity = SearchActivity.last

      expect(search_activity.search_terms).to eq('test')
      expect(response.status).to eq(302)
      expect(response).to redirect_to(search_activity_path(search_activity.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of search activity' do
      search_activity = create(:search_activity)

      put :update, id: search_activity.id, search_activity: { search_terms: 'new search terms' }

      search_activity = SearchActivity.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(search_activity_path(search_activity.id))
      expect(search_activity.search_terms).to eq('new search terms')
    end

    it 'redirects away when no search_activity id is given' do
      put :update, id: 'nonsense id', search_activity: { search_terms: 'new search terms' }

      expect(response).to redirect_to(search_activities_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of search activity' do
      search_activity = create(:search_activity)

      delete :destroy, id: search_activity.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(search_activities_path)
      expect(SearchActivity.all.size).to eq(0)
    end
  end
end
