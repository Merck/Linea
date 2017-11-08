# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe MyDatasetsController, type: :controller do
  describe 'Create new dataset with new tags' do
    let(:current_user) { create(:user) }
    let(:time_tag) { "tag_#{Time.now.to_i}" }
    let!(:another_tag) { create :tag }
    let(:datasource) { create :datasource }
    let(:subject_area) { create :subject_area }
    let(:dataset_params) {
      { 'dataset' => {'name'=>'name', 'description'=>'desc', 'terms_of_service_name'=>'asdas',
        'subject_area_id'=> subject_area.id, 'tag_ids'=>[ another_tag.name, time_tag], 'country_code'=>'', 'datasource_id' => datasource.id}
      }
    }
    before do
      session[:user_id] = current_user.id
    end
    it 'ensures new tag does exist' do
      expect{ post :create, dataset_params }.to change(Tag, :count).by(1)
    end

  end

  describe 'GET new' do
    let(:current_user) { create(:user, username: 'usr_1') }
    let(:terms_of_service) { create(:terms_of_service , name: 'TEST terms of service 333') }
    let(:my_datasets) { [
      create(:dataset, terms_of_service: terms_of_service ,terms_of_service_name: terms_of_service.name),
      create(:dataset, owner: current_user,terms_of_service: terms_of_service , terms_of_service_name: terms_of_service.name)
    ] }

    before do
      create(:request_access,
             dataset_id: my_datasets.first.id,
             user_id: current_user.id,
             status: :approved)
      session[:user_id] = current_user.id
    end
    it 'renders new form' do
      get :new
      expect(assigns(:dataset)).to be_an_instance_of(Dataset)
      expect(assigns(:my_datasets)).to eq(my_datasets)
    end

  end

  describe 'GET edit' do
    context 'when the user is not an owner or an admin of the dataset ' do
      let(:current_user) { create(:user) }
      let(:terms_of_service) { create(:terms_of_service , name: 'TEST terms of service 777') }
      let(:dataset) { create(:dataset, terms_of_service: terms_of_service,  terms_of_service_name: terms_of_service.name) }

      before do
        session[:user_id] = current_user.id
      end

      it 'redirects to the root path and shows a error message' do
        get :edit, id: dataset.id

        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq('You do not have access to edit this dataset.')
      end
    end

    context 'when the user is an owner of the dataset' do
      let(:current_user) { create(:user) }
      let(:terms_of_service) { create(:terms_of_service , name: 'TEST terms of service 888') }
      let(:dataset) { create(:dataset, owner_id: current_user.id, terms_of_service: terms_of_service, terms_of_service_name: terms_of_service.name) }

      before do
        session[:user_id] = current_user.id
        create(:middlegate_access_check,
               user_id: current_user.id,
               last_checked_at: Time.zone.now,
               has_access: true)
      end

      it 'renders the edit form' do
        get :edit, id: dataset.id

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
        expect(assigns(:dataset)).to eq(dataset)
      end
    end

    context 'when the user is an admin of the dataset' do
      let(:current_user) { create :admin_user }
      let(:terms_of_service) { create(:terms_of_service , name: 'Test terms of service') }
      let(:dataset) { create(:dataset, terms_of_service: terms_of_service , terms_of_service_name: 'Test terms of service 1') }

      before do
        session[:user_id] = current_user.id
        create(:middlegate_access_check,
               user_id: current_user.id,
               last_checked_at: Time.zone.now,
               has_access: true)
      end

      it 'renders the edit form' do
        get :edit, id: dataset.id

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
        expect(assigns(:dataset)).to eq(dataset)
      end
    end
  end

  describe 'GET update' do
    context 'when the user is not an owner or an admin of the dataset ' do
      let(:current_user) { create(:user) }
      let(:terms_of_service) { create(:terms_of_service , name: 'TEST terms of service INIT') }
      let(:dataset) { create(:dataset , terms_of_service: terms_of_service , terms_of_service_name: terms_of_service.name) }

      before do
        session[:user_id] = current_user.id
      end

      it 'redirects to the root path and shows a error message' do
        get :update, id: dataset.id

        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq('You do not have access to edit this dataset.')
      end
    end

  end

  describe 'POST create' do
    context 'when user creates catalog entry' do
      let(:current_user) { create(:user, username: 'usr_3') }
      let(:tag) { create(:tag) }
      let(:datasource) { create(:datasource) }
      let(:subject_area) { create(:subject_area) }

      before do
        session[:user_id] = current_user.id
      end

      it 'creates dataset only on Linea side' do
        post :create, dataset: {
            name: 'New dataset',
            description: 'New description',
            tag_ids: [tag.id],
            terms_of_service_name: 'TEST terms of service',
            subject_area_id: subject_area.id,
            datasource_id: datasource.id,
            restricted: 'public'
        }

        expect(response).to redirect_to(mydatasets_path)

        dataset = Dataset.last
        expect(dataset.name).to eq('New dataset')
        expect(dataset.description).to eq('New description')
        expect(dataset.tags.map(&:id)).to eq([tag.id])
        expect(dataset.terms_of_service.name).to eq('TEST terms of service')
        expect(dataset.subject_area).to eq(subject_area)
        expect(dataset.restricted).to eq('public')
        expect(dataset.external_id).to eq(nil)
        expect(dataset.middlegate_type).to eq(nil)

      end
    end
  end

  describe 'DELETE destroy' do
    context 'when the user is not the dataset owner nor admin' do
      let(:current_user) { create :user }
      let(:dataset) { create(:dataset, owner: nil) }

      before do
        session[:user_id] = current_user.id
      end

      it 'redirects to the root path and shows error message' do
        delete :destroy, id: dataset.id

        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq('You do not have access to remove this dataset.')
      end
    end

    context 'when the user is the dataset owner' do
      let!(:current_user) { create(:user) }
      let!(:dataset) { create(:dataset, owner: current_user, middlegate_type: nil) }

      before do
        session[:user_id] = current_user.id
        create(:middlegate_access_check,
               user_id: current_user.id,
               last_checked_at: Time.zone.now,
               has_access: true)
      end

      it 'removes the dataset from the catalog' do
        expect do
          delete :destroy, id: dataset.id
        end.to change(Dataset, :count).by(-1)
        expect(response).to redirect_to(mydatasets_path)
      end
    end

    context 'when the user is an admin' do
      let!(:current_user) { create :admin_user }
      let!(:dataset) { create(:dataset, middlegate_type: nil) }

      before do
        session[:user_id] = current_user.id
        create(:middlegate_access_check,
               user_id: current_user.id,
               last_checked_at: Time.zone.now,
               has_access: true)
      end

      it 'removes the dataset from the catalog' do
        expect do
          delete :destroy, id: dataset.id
        end.to change(Dataset, :count).by(-1)

        expect(assigns(:dataset)).to eq(dataset)
        expect(response).to redirect_to(mydatasets_path)
      end
    end
  end
end
