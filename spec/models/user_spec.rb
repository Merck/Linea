# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe User do
  describe 'associations' do

    it { should have_many(:view_activities) }
    it { should have_many(:share_activities) }
    it { should have_many(:review_activities) }
    it { should have_many(:ingest_activities) }
    it { should have_many(:owned_datasets).class_name('Dataset') }
    it { should have_many(:notes) }
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end

  describe 'scopes' do
    it 'returns allowed users for given dataset' do
      allowed_user = create(:user)
      forbidden_user = create(:user)

      dataset = create(:dataset)
      create(:request_access, dataset_id: dataset.id, user_id: allowed_user.id, status: 'approved')
      create(:request_access, dataset_id: dataset.id, user_id: forbidden_user.id, status: 'rejected')

      expect(Pundit.policy_scope(dataset, User)).to eq([allowed_user])
    end
  end

  describe 'terms of use acceptance' do
    let(:user) { create :user }
    let!(:terms_of_use_1) { create :terms_of_use, valid_from: 1.day.ago }
    let!(:terms_of_use_2) { create :terms_of_use, valid_from: 2.days.ago }

    context 'has latest accepted' do
      let!(:acceptance) { create :terms_acceptance, terms_of_use_id: terms_of_use_1.id, user_id: user.id }
      it { expect(TermsOfUse.latest.first).to eq terms_of_use_1 }
      it { expect(user.accepted_latest_terms_of_use?).to be_truthy }
    end

    context 'has nothing accepted' do
      it { expect(user.accepted_latest_terms_of_use?).to be_falsey }
    end

    context 'has not latest accepted' do
      let!(:acceptance) { create :terms_acceptance, terms_of_use_id: terms_of_use_2.id, user_id: user.id }
      it { expect(TermsOfUse.latest.first).to eq terms_of_use_1 }
      it { expect(user.accepted_latest_terms_of_use?).to be_falsey }
    end
  end
end
