# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe RequestAccessPolicy do
  subject { described_class }

  permissions :resolved? do
    it "return true if it's already approved" do
      user = create(:user)
      request_access = create(:request_access, user_id: user.id, status: 'approved')

      expect(subject).to permit(user, request_access.id)
    end

    it 'return false otherwise' do
      user = create(:user)
      request_access = create(:request_access, user_id: user.id, status: 'waiting')

      expect(subject).not_to permit(user, request_access.id)
    end
  end

  context 'scope' do
    it 'return empty requests if user already resolved all requests' do
      user = create(:user)
      dataset = create(:dataset, owner_id: user.id)
      request_access = create(:request_access, status: 1, dataset_id: dataset.id)
      request_access = create(:request_access, status: 2, dataset_id: dataset.id)

      expect(subject::Scope.new(user, RequestAccess).resolve).to be_empty
    end

    it 'return pending requests' do
      user = create(:user)
      dataset = create(:dataset, owner_id: user.id)
      request_access = create(:request_access, status: 0, dataset_id: dataset.id)
      request_access = create(:request_access, status: 0, dataset_id: dataset.id)

      expect(subject::Scope.new(user, RequestAccess).resolve.count).to eq(2)
    end
  end
end
