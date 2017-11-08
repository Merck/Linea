# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe DatasetAttribute do
  describe 'associations' do
    it { is_expected.to belong_to(:dataset) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_uniqueness_of(:key).scoped_to(:dataset_id) }
  end

  describe 'creating' do
    context 'does not exists' do
      let(:attribute) { build :dataset_attribute }
      it 'gets saved' do
        expect do
          attribute.save
        end.to change(DatasetAttribute, :count).by(1)
      end

      let(:es) { double }
      before do
        allow(attribute.dataset).to receive(:document_reindex)
      end

      it 'calls reindex' do
        attribute.save
        attribute.run_callbacks(:commit)
        expect(attribute.dataset).to have_received(:document_reindex).once
      end
    end

    context 'already exists in the same dataset' do
      let!(:attribute) { create :dataset_attribute }
      let(:attribute2) { build :dataset_attribute, key: attribute.key, dataset_id: attribute.dataset_id }
      it 'does not get saved' do
        expect do
          attribute2.save
        end.to change(DatasetAttribute, :count).by(0)
      end

      it 'does not get saved (must be case insensitive)' do
        attribute2.key.upcase!
        expect do
          attribute2.save
        end.to change(DatasetAttribute, :count).by(0)
      end

    end

    context 'already exists in the another dataset' do
      let!(:attribute) { create :dataset_attribute }
      let(:attribute2) { build :dataset_attribute, key: attribute.key }
      it 'gets saved' do
        expect do
          attribute2.save
        end.to change(DatasetAttribute, :count).by(1)
      end

    end

  end

  describe 'updating' do
    context 'does not exists' do
      let!(:attribute) { create :dataset_attribute }
      let!(:attribute2) { create :dataset_attribute }
      before { attribute2.key = 'some other key' }
      subject { attribute2 }

      it { is_expected.to be_valid }

      let(:es) { double }
      before do
        allow(subject.dataset).to receive(:document_reindex)
      end

      it 'calls reindex' do
        subject.save
        subject.run_callbacks(:commit)
        expect(subject.dataset).to have_received(:document_reindex).once
      end

    end

    context 'already exists in the same dataset' do
      let!(:attribute) { create :dataset_attribute }
      let!(:attribute2) { create :dataset_attribute, key: 'another key', dataset_id: attribute.dataset_id }

      before { attribute2.key = attribute.key }
      subject { attribute2 }

      it { is_expected.not_to be_valid }
    end

  end

  describe 'destroying' do
    let!(:attribute) { create :dataset_attribute }
    let(:es) { double }

    before do
      allow(attribute.dataset).to receive(:document_reindex)
    end

    it 'calls reindex' do
      attribute.destroy
      attribute.run_callbacks(:commit)
      expect(attribute.dataset).to have_received(:document_reindex).once
    end
  end

  describe 'autocomplete' do
    let!(:dataset) { create :dataset }
    let!(:dataset_2) { create :dataset }
    let!(:attrib_1) { create :dataset_attribute, key: 'my key', dataset_id: dataset.id }
    let!(:attrib_2) { create :dataset_attribute, key: 'my other key', dataset_id: dataset_2.id }

    context 'any key' do
      subject { DatasetAttribute.autocomplete(query: 'm') }
      it { is_expected.to eq ['my key', 'my other key'] }
    end

    context 'exclude already used key in given dataset' do
      subject { DatasetAttribute.autocomplete(query: 'm', except: dataset.id) }
      it { is_expected.to eq ['my other key'] }
    end

    context 'no key' do
      subject { DatasetAttribute.autocomplete(query: 'non') }
      it { is_expected.to eq [] }
    end

  end

end
