# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
describe DatasetPolicy do
  subject { described_class }

  permissions :owner? do
    it 'denies access if user is not owner of dataset' do
      current_user = create(:user)
      owner_user = create(:user)

      dataset = create(:dataset, owner_id: owner_user.id)

      expect(subject).not_to permit(current_user, dataset)
    end

    it 'grants access if user is owner of dataset' do
      owner_and_current_user = create(:user)
      dataset = create(:dataset, owner_id: owner_and_current_user.id)

      expect(subject).to permit(owner_and_current_user, dataset)
    end

    it 'grants access if user is general admin' do
      admin = create(:user, is_admin: true)
      dataset = create(:dataset)

      expect(subject).to permit(admin, dataset)
    end
  end

  permissions :admin? do
    let(:user) { create(:user) }
    let(:dataset) { create(:dataset) }

    it 'grants access if user is admin of dataset' do
      request = create(:request_access, dataset_id: dataset.id, user_id: user.id,
        status: 'approved', role_type: 'admin')
      expect(subject).to permit(user, dataset)
    end
  end

  permissions :can_request_access? do
    let(:current_user) { create(:user) }
    let(:owner_user) { create(:user) }

    it 'denies access if user already requested access for dataset' do
      dataset = create(:dataset, owner_id: owner_user.id)
      dataset.request_accesses.build(user_id: current_user.id, status: 'approved').save
      expect(subject).not_to permit(current_user, dataset)
    end

    it 'grants access if user do not requested access for dataset yet' do
      dataset = create(:dataset, owner_id: owner_user.id)

      expect(subject).to permit(current_user, dataset)
    end
  end

  context 'scope' do
    let(:user) { create(:user) }
    let(:dataset) { create(:dataset, owner_id: user.id) }
    let(:dataset2) { create(:dataset) }

    before do
      request_access = create(:request_access, status: 'waiting', dataset_id: dataset.id, user_id: user.id)
      request_access = create(:request_access, status: 'approved', dataset_id: dataset2.id, user_id: user.id)
    end

    it 'return my datasets' do
      expect(subject::Scope.new(user, Dataset).resolve.count).to eq(2)
    end
  end
end
