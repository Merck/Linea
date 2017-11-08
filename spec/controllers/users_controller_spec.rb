# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe UsersController, type: :controller do
  describe 'MyDatasets' do
    it 'renders datasets which I own and those I have access to' do
      current_user = create(:user, is_admin: true)
      session[:user_id] = current_user.id

      dataset = create(:dataset)
      dataset2 = create(:dataset)
      dataset3 = create(:dataset)
      dataset4 = create(:dataset, owner_id: current_user.id)

      request = create(:request_access, user_id: current_user.id, owner_id: current_user.id, dataset_id: dataset.id, status: 'approved')
      request = create(:request_access, user_id: current_user.id, owner_id: current_user.id, dataset_id: dataset2.id, status: 'approved')
      request = create(:request_access, user_id: current_user.id, owner_id: current_user.id, dataset_id: dataset3.id, status: 'rejected')

      get :mydatasets
      expect(assigns(:my_datasets)).to include(dataset)
      expect(assigns(:my_datasets)).to include(dataset2)
      expect(assigns(:my_datasets)).to include(dataset4)
      expect(assigns(:my_datasets)).not_to include(dataset3)

      expect(assigns(:owned_datasets)).to eq([dataset4])
      expect(assigns(:admin_datasets).size).to eq(2)
      expect(assigns(:admin_datasets)).to include(dataset, dataset2)
      
      expect(assigns(:current_user)).to eq(current_user)
    end
  end
end
