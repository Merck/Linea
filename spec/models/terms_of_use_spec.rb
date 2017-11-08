# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe TermsOfUse do
  describe 'associations' do
    it { is_expected.to have_many(:terms_acceptances) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:terms) }
    it { is_expected.to validate_presence_of(:valid_from) }
  end

  describe 'fetch latest' do
    context 'with valid_to open' do
      let!(:terms_1) { create :terms_of_use, valid_from: 2.days.ago }
      let!(:terms_2) { create :terms_of_use, valid_from: 1.days.ago }
      it 'returns latest ToU' do
        expect(TermsOfUse.latest).to eq [terms_2, terms_1]
      end
    end

    context 'with valid_to closed' do
      let!(:terms_1) { create :terms_of_use, valid_from: 2.days.ago }
      let!(:terms_2) { create :terms_of_use, valid_from: 1.days.ago, valid_to: 1.days.ago + 12.hours }
      it 'returns latest ToU' do
        expect(TermsOfUse.latest).to eq [terms_1]
      end
    end
  end

  describe 'remove acceptances too' do
    let!(:terms) { create :terms_of_use }
    let!(:terms_acceptance) { create :terms_acceptance, terms_of_use: terms }
    it 'destroys terms_acceptance too' do
      expect{terms.destroy}.to change(TermsAcceptance, :count).by(-1)
    end
  end
end
