# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe DatasetTag do
  describe 'associations' do
    it { should belong_to(:taggedby) }
    it { should belong_to(:dataset) }
    it { should belong_to(:tag) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:dataset) }
    it { is_expected.to validate_presence_of(:tag) }
  end

  describe 'validations - uniqueness' do
    before do
      subject.tag = build :tag
      subject.dataset = build :dataset
    end
    it { is_expected.to validate_uniqueness_of(:tag_id).scoped_to(:dataset_id) }
  end

  describe 'tag uniqueness in dataset scope' do
    let!(:dataset) { create :dataset }
    let!(:tag) { create :tag, name: 'sample tag' }
    before { create :dataset_tag, dataset_id: dataset.id, tag_id: tag.id }
    subject { build :dataset_tag, dataset_id: dataset.id, tag_id: tag.id }
    it { expect(subject.valid?).to be_falsey }
  end

  describe 'tag removal' do
    let(:dataset) { create :dataset }
    let!(:tag) { create :tag, name: 'some tag' }
    let!(:dataset_tag) { create :dataset_tag, tag: tag, dataset: dataset }

    it 'destroys tag too' do
      expect{ dataset.destroy }.to change(Tag, :count).by(-1)
    end
  end
end
