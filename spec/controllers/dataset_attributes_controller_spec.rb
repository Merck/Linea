# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

RSpec.describe DatasetAttributesController, type: :controller do
  let(:current_user) { create(:user) }
  let!(:dataset) { create :dataset, owner_id: current_user.id }

  it 'does want be authenticated' do
    get :edit, dataset_id: dataset.id, id: 1
    expect(response.code).to eq "302"
    expect(response).to redirect_to(action: :login, controller: :sessions)
  end

  describe 'creating' do
    let(:params) { { key: 'some key 1234', value: 'some value 1234' } }
    before { session[:user_id] = current_user.id }
    it 'does create new attribute' do
      expect do
        post :create, dataset_id: dataset.id, dataset_attribute: params, format: :js
      end.to change(DatasetAttribute, :count).by(1)
      expect(response.code).to eq "200"
    end

    it 'does not create new attribute' do
      post :create, dataset_id: dataset.id, dataset_attribute: params, format: :js

      expect do
        post :create, dataset_id: dataset.id, dataset_attribute: params, format: :js
      end.to change(DatasetAttribute, :count).by(0)
      expect(response.code).to eq "422"
    end
  end

  describe 'updating' do
    let!(:attribute) { create :dataset_attribute, dataset_id: dataset.id }
    let(:params) { { key: 'some key 1234', value: 'some value 1234' } }
    let(:invalid_params) { { key: attribute.key, value: 'some value 1234' } }

    before { session[:user_id] = current_user.id }

    it 'does update an attribute' do
      put :update, dataset_id: dataset.id, id: attribute.id, dataset_attribute: params, format: :js
      attribute.reload
      expect(attribute.key).to eq params[:key]
      expect(response.code).to eq "200"
    end

    it 'does not update an attribute' do
      post :create, dataset_id: dataset.id, id: attribute.id, dataset_attribute: invalid_params, format: :js
      expect(response.code).to eq "422"
    end
  end

 describe 'destroying' do
    let!(:attribute) { create :dataset_attribute, dataset_id: dataset.id }

    before { session[:user_id] = current_user.id }

    it 'does remove an attribute' do
      expect do
        delete :destroy, dataset_id: dataset.id, id: attribute.id, format: :js
      end.to change(DatasetAttribute, :count).by(-1)
      expect(response.code).to eq "200"
    end
  end


end
