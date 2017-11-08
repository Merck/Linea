# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe LikeActivitiesController, type: :controller  do
  before do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe 'GET index' do
    it 'renders all the like activities' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'renders single like activity instance' do
      like_activity = create(:like_activity)

      get :show, id: like_activity.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new like_activity' do
      dataset = create(:dataset)
      user = create(:user)

      post :create, like_activity: { dataset_id: dataset.id, user_id: user.id }
      like_activity = LikeActivity.last

      expect(like_activity).not_to be_nil
      expect(response.status).to eq(302)
      expect(response).to redirect_to(like_activity_path(like_activity.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of like_activity' do
      like_activity = create(:like_activity)
      dataset = create(:dataset)

      put :update, id: like_activity.id, like_activity: { dataset_id: dataset.id }

      like_activity = LikeActivity.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(like_activity_path(like_activity.id))
      expect(like_activity.dataset).to eq(dataset)
    end

    it 'redirects away when no like_activity id is given' do
      put :update, id: 'nonsense id', like_activity: { dataset_id: nil }

      expect(response).to redirect_to(like_activities_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of like activity' do
      like_activity = create(:like_activity)

      delete :destroy, id: like_activity.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(like_activities_path)
      expect(LikeActivity.all.size).to eq(0)
    end
  end
end
