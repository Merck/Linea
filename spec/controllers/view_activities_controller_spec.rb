# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe ViewActivitiesController, type: :controller  do
  before do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe 'GET index' do
    it 'renders all the dataset algorithms' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'renders single dataset algorithm instance' do
      view_activity = create(:view_activity)

      get :show, id: view_activity.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new dataset algorithm' do
      dataset = create(:dataset)
      user = create(:user)

      post :create, view_activity: { dataset_id: dataset.id, user_id: user.id }
      view_activity = ViewActivity.last

      expect(view_activity).not_to be_nil
      expect(response.status).to eq(302)
      expect(response).to redirect_to(view_activity_path(view_activity.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of dataset algorithm' do
      view_activity = create(:view_activity)
      dataset = create(:dataset)

      put :update, id: view_activity.id, view_activity: { dataset_id: dataset.id }

      view_activity = ViewActivity.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(view_activity_path(view_activity.id))
      expect(view_activity.dataset).to eq(dataset)
    end

    it 'redirects away when no algorithm id is given' do
      put :update, id: 'nonsense id', view_activity: { dataset_id: nil }

      expect(response).to redirect_to(view_activities_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of dataset algorithm' do
      view_activity = create(:view_activity)

      delete :destroy, id: view_activity.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(view_activities_path)
      expect(ViewActivity.all.size).to eq(0)
    end
  end
end
