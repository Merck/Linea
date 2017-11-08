# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

RSpec.describe IndexDatasetWorker do
  describe 'perform' do
    let(:dataset) { double :dataset, id: 1 }

    before do
      allow(Dataset).to receive(:find).with(1).and_return(dataset)
      allow(dataset).to receive_message_chain(:__elasticsearch__, :index_document)
    end

    it { is_expected.to be_processed_in :elastic }
    it { is_expected.to be_retryable false }

    it 'expects to index document' do
      expect(dataset).to receive(:__elasticsearch__)
      subject.perform(dataset.id)
    end
  end
end
