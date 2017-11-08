# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe Note do
  context 'validations' do
    it 'has a valid factory' do
      dataset = build_stubbed(:dataset)
      user = build_stubbed(:user)
      expect(build_stubbed(:note, dataset: dataset, user: user)).to be_valid
    end

    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :dataset }
    it { is_expected.to validate_presence_of :user }
  end

  describe 'counter cache' do
    let!(:user) { create(:user) }
    let!(:note) { create(:note, dataset: dataset, user: user) }
    let!(:dataset) { create(:dataset) }

    it 'sets counter cache' do
      expect(dataset.notes_count).to eq 1
    end

    it 'decreases counter cache' do
      expect { user.notes.first.destroy }.to change(dataset.notes, :count).by(-1)
    end
  end

  context 'attribute delagations' do
    let(:dataset) { build_stubbed(:dataset) }
    let(:user) { build_stubbed(:user) }
    let(:note) { build_stubbed(:note, dataset: dataset, user: user) }

    it 'delegates full name to User' do
      expect(note.full_name).to eq user.full_name
    end

    it 'delegates avatar_path to User' do
      expect(note.avatar_path).to eq user.avatar_path
    end
  end
end
