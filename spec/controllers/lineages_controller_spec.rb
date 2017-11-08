# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe LineagesController, type: :controller  do
  before do
    @user = create(:user, is_admin: true)
    admin = create(:user, is_admin: true, username: 'shosanna')
    session[:user_id] = admin.id
  end

  describe 'GET index' do
    it 'renders all the lineages' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'renders single lineage instance' do
      lineage = create(:lineage)

      get :show, id: lineage.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new lineage' do
      child_dataset = create(:dataset)
      parent_dataset = create(:dataset)
      post :create, lineage: { comment: 'test',
                               child_dataset_id: child_dataset.id,
                               parent_dataset_id: parent_dataset.id }

      lineage = Lineage.last

      expect(lineage.comment).to eq('test')
      expect(response.status).to eq(302)
      expect(response).to redirect_to(lineage_path(lineage.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of lineage' do
      lineage = create(:lineage)
      child_dataset = create(:dataset)
      parent_dataset = create(:dataset)

      put :update, id: lineage.id, lineage: { comment: 'new comment',
                                              child_dataset_id: child_dataset.id,
                                              parent_dataset_id: parent_dataset.id }

      lineage = Lineage.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(lineage_path(lineage.id))
      expect(lineage.comment).to eq('new comment')
      expect(lineage.child_dataset_id).to eq(child_dataset.id)
      expect(lineage.parent_dataset_id).to eq(parent_dataset.id)
    end

    it 'redirects away when no lineage id is given' do
      put :update, id: 'nonsense id', lineage: { comment: 'new comment' }

      expect(response).to redirect_to(lineages_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of lineage' do
      lineage = create(:lineage)

      delete :destroy, id: lineage.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(lineages_path)
      expect(Lineage.all.size).to eq(0)
    end
  end

  describe 'GET details' do
    it 'returns detail of one lineage' do
      lineage = create(:lineage)
      get :details, id: lineage.id

      expect(assigns(:lineage)).to eq(lineage)
    end
  end
end
