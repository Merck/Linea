# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe ReviewActivitiesController, type: :controller  do
  before do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe 'GET index' do
    it 'renders all the review activities' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'renders single review activity instance' do
      review_activity = create(:review_activity)

      get :show, id: review_activity.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new review_activity' do
      dataset = create(:dataset)
      user = create(:user)

      post :create, review_activity: { dataset_id: dataset.id, user_id: user.id, review: 'testing review' }
      review_activity = ReviewActivity.last

      expect(review_activity).not_to be_nil
      expect(review_activity.review).to eq('testing review')
      expect(response.status).to eq(302)
      expect(response).to redirect_to(dataset_path(review_activity.dataset.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of review_activity' do
      review_activity = create(:review_activity)
      dataset = create(:dataset)

      put :update, id: review_activity.id, review_activity: { dataset_id: dataset.id }

      review_activity = ReviewActivity.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(review_activity_path(review_activity.id))
      expect(review_activity.dataset).to eq(dataset)
    end

    it 'redirects away when no review_activity id is given' do
      put :update, id: 'nonsense id', review_activity: { dataset_id: nil }

      expect(response).to redirect_to(review_activities_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of review activity' do
      review_activity = create(:review_activity)

      delete :destroy, id: review_activity.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(dataset_path(review_activity.dataset.id))
      expect(ReviewActivity.all.size).to eq(0)
    end
  end
end
