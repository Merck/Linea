# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe Dataset::RequestAccessesController, type: :controller  do
  describe 'GET index for owners' do
    it 'renders an ordered list of all access requests for given owner' do
      current_user = create(:user)
      session[:user_id] = current_user.id
      dataset = create(:dataset, owner_id: current_user.id)
      request_access1 = create(:request_access,
                               dataset_id: dataset.id,
                               owner_id: dataset.owner_id,
                               status: :rejected)
      request_access2 = create(:request_access,
                               dataset_id: dataset.id,
                               status: :approved)
      request_access3 = create(:request_access,
                               dataset_id: dataset.id,
                               owner_id: dataset.owner_id,
                               status: :waiting)
      request_access4 = create(:request_access,
                               dataset_id: dataset.id,
                               owner_id: dataset.owner_id,
                               status: :waiting,
                               created_at: request_access3.created_at - 1.minute)
      get :index, id: dataset.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
      expect(assigns(:request_accesses)).to eq([
        request_access4,
        request_access3,
        request_access2,
        request_access1
      ])
    end
  end

  describe 'POST create' do
    it 'creates single instance of a new request access' do
      current_user = create(:user)
      session[:user_id] = current_user.id

      owner = create(:user)
      dataset = create(:dataset, owner_id: owner.id, restricted: 'private')
      create(:middlegate_access_check,
        user_id: current_user.id,
        last_checked_at: Time.zone.now,
        has_access: true)

      post :create, id: dataset.id

      request_access = RequestAccess.last

      expect(response.status).to eq(302)
      expect(request_access.user).to eq(current_user)
      expect(request_access.dataset).to eq(dataset)
      expect(request_access.owner_email).to eq(owner.email)
      expect(response).to redirect_to(dataset_path(dataset.id))
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  describe 'GET approve' do
    it 'approves request access by the owner of the dataset' do
      current_user = create(:user)
      session[:user_id] = current_user.id

      dataset = create(:dataset, owner_id: current_user.id)
      dataset.save_external_id
      dataset.save!
      request_access = create(:request_access, dataset_id: dataset.id, status: 'waiting', owner_id: current_user.id)
      create(:middlegate_access_check,
        user_id: current_user.id,
        last_checked_at: Time.zone.now,
        has_access: true)

      post :approve, id: dataset.id, request_access_id: request_access.id

      expect(request_access.reload.approved?).to eq(true)
      expect(response).to redirect_to(
        dataset_request_accesses_path(
          id: dataset.id
        )
      )
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  describe 'GET reject' do
    it 'rejects request access by the owner of the dataset' do
      current_user = create(:user)
      session[:user_id] = current_user.id

      dataset = create(:dataset, owner_id: current_user.id)
      request_access = create(:request_access, dataset_id: dataset.id)
      create(:middlegate_access_check,
        user_id: current_user.id,
        last_checked_at: Time.zone.now,
        has_access: true)

      post :reject, id: dataset.id, request_access_id: request_access.id

      expect(request_access.reload.rejected?).to eq(true)
      expect(response).to redirect_to(
        dataset_request_accesses_path(
          id: dataset.id
        )
      )
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end
end
