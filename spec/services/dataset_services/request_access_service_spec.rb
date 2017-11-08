# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe DatasetServices::RequestAccessService do
  describe '#initiate' do
    context 'when the dataset is public' do
      let(:user) { create(:user, username: 'usr') }
      let(:owner) { create(:user, username: 'owner') }
      let(:dataset) { create(:dataset,
                         restricted: 'public',
                         owner: owner,
                         external_id: 'id') }

      before do
        described_class.new(dataset_id: dataset.id, user_id: user.id,
        owner_id: dataset.owner_id).initiate
      end

      it 'automatically approves the request' do
        expect(dataset.request_accesses.size).to eq 1
        request_access = dataset.request_accesses.first
        expect(request_access.status).to eq 'approved'
        expect(request_access.user_id).to eq(user.id)
      end
    end

    context 'when the dataset is not public' do
      let(:user) { create(:user, username: 'usr') }
      let(:owner) { create(:user, username: 'owner', email: 'owner@company.com') }
      let(:dataset) { create(:dataset,
                         owner: owner,
                         name: 'ds1',
                         external_id: 'id',
                         restricted: 'private') }

      before do
        described_class.new(dataset_id: dataset.id, user_id: user.id).initiate
      end

      it "creates a request and sends a notification to the owner" do
        expect(dataset.request_accesses.size).to eq(1)
        request_access = dataset.request_accesses.first
        expect(request_access.status).to eq 'approved'
        expect(request_access.user_id).to eq(user.id)

        expect(ActionMailer::Base.deliveries.size).to eq(1)
        delivery = ActionMailer::Base.deliveries.first
        expect(delivery.to).to eq(['owner@company.com'])
        expect(delivery.subject).to eq 'Linea dataset access request for ds1'
      end
    end
  end
end
