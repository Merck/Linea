# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe TermsAcceptance do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:terms_of_use) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:terms_of_use) }
    it { is_expected.to validate_uniqueness_of(:terms_of_use_id).scoped_to(:user_id) }
  end

  describe 'latest accepted' do
    let!(:terms_1) { create :terms_of_use, valid_from: 2.days.ago }
    let!(:terms_2) { create :terms_of_use, valid_from: 1.days.ago }
    let(:user) { create :user }

    context 'old terms' do
      let(:accepted) { create :terms_acceptance, user_id: user.id, terms_of_use_id: terms_1.id, accepted_at: 1.day.ago }
      it 'is false' do
        expect(accepted.latest_accepted?).to be_falsey
      end
    end

    context 'old terms' do
      let(:accepted) { create :terms_acceptance, user_id: user.id, terms_of_use_id: terms_2.id, accepted_at: Time.now }
      it 'is true' do
        expect(accepted.latest_accepted?).to be_truthy
      end
    end
  end

end
