# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe SubjectAreasController, type: :controller  do
  before do
    @user = create(:user, is_admin: true)
    admin = create(:user, is_admin: true, username: 'admin')
    session[:user_id] = admin.id
  end

  describe 'GET index' do
    it 'renders all the subject areas' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'renders single subject_area instance' do
      subject_area = create(:subject_area)

      get :show, id: subject_area.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new subject_area' do
      post :create, subject_area: { name: 'test' }

      subject_area = SubjectArea.last

      expect(subject_area.name).to eq('test')
      expect(response.status).to eq(302)
      expect(response).to redirect_to(subject_area_path(subject_area.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of subject_area' do
      subject_area = create(:subject_area)

      put :update, id: subject_area.id, subject_area: { name: 'new name' }

      subject_area = SubjectArea.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(subject_area_path(subject_area.id))
      expect(subject_area.name).to eq('new name')
    end

    it 'redirects away when no subject_area id is given' do
      put :update, id: 'nonsense id', subject_area: { name: 'new name' }

      expect(response).to redirect_to(subject_areas_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of subject_area' do
      subject_area = create(:subject_area)

      delete :destroy, id: subject_area.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(subject_areas_path)
      expect(SubjectArea.all.size).to eq(0)
    end
  end
end
