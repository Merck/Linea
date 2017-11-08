# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe Tag do
  describe 'associations' do
    it { should have_many(:datasets) }
    it { should have_many(:dataset_tags) }
    it { should belong_to(:created_by) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'name is lowercase' do
    let(:tag) { create :tag, name: 'SoME tag' }
    it { expect(tag.name).to eq 'some tag' }
  end

  describe 'can not create the same tag twice' do
    let!(:tag) { create :tag, name: 'some tag' }
    subject { build :tag, name: 'some tag' }
    it { expect(subject.valid?).to be_falsey }
  end

  describe 'tag removal' do
    let!(:dataset) { create :dataset }
    let!(:tag) { create :tag, name: 'some tag' }
    let!(:dataset_tag) { create :dataset_tag, tag: tag, dataset: dataset }

    context 'no other dataset uses the tag' do
      it 'has one dataset linked' do
        expect(tag.datasets.count).to eq 1
      end
      it 'has one dataset' do
        expect(dataset.dataset_tags.first.tag).to eq tag
      end
      it 'must remove the tag' do
        expect { dataset.destroy }.to change(Tag, :count).by(-1)
      end
    end

    context 'another dataset uses the tag' do
      let(:dataset_other) { create :dataset }
      let!(:dataset_tag_other) { create :dataset_tag, tag: tag, dataset: dataset_other }
      it 'has two datasets linked' do
        expect(tag.datasets.count).to eq 2
      end

      it 'must NOT remove the tag' do
        expect { dataset.destroy }.to change(Tag, :count).by(0)
      end
    end
  end
end
