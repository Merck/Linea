# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe DatasetAlgorithmsController, type: :controller  do
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
      dataset_algorithm = create(:dataset_algorithm)

      get :show, id: dataset_algorithm.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new dataset algorithm' do
      dataset = create(:dataset)
      alg = create(:algorithm)

      post :create, dataset_algorithm: { dataset_id: dataset.id, algorithm_id: alg.id }
      dataset_algorithm = DatasetAlgorithm.last

      expect(dataset_algorithm).not_to be_nil
      expect(response.status).to eq(302)
      expect(response).to redirect_to(dataset_algorithm_path(dataset_algorithm.id))
    end
  end

  describe 'PUT update' do
    it 'updates existing instance of dataset algorithm' do
      dataset_algorithm = create(:dataset_algorithm)
      dataset = create(:dataset)

      put :update, id: dataset_algorithm.id, dataset_algorithm: { dataset_id: dataset.id }

      dataset_algorithm = DatasetAlgorithm.last
      expect(response.status).to eq(302)
      expect(response).to redirect_to(dataset_algorithm_path(dataset_algorithm.id))
      expect(dataset_algorithm.dataset).to eq(dataset)
    end

    it 'redirects away when no algorithm id is given' do
      put :update, id: 'nonsense id', dataset_algorithm: { dataset_id: nil }

      expect(response).to redirect_to(dataset_algorithms_path)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes existing instance of dataset algorithm' do
      dataset_algorithm = create(:dataset_algorithm)

      delete :destroy, id: dataset_algorithm.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to(dataset_algorithms_path)
      expect(DatasetAlgorithm.all.size).to eq(0)
    end
  end
end
