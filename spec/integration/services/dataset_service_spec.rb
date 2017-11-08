# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require_relative '../../spec_helper_integration'

xdescribe DatasetService, :integration => true do
  describe '.create' do
    let(:dataset) { FactoryGirl.create(:dataset) }
    let(:dataset_with_table) { FactoryGirl.create(:dataset, :with_table) }
    let(:scheduled_once) { FactoryGirl.build(:dataset_scheduling) }
    let(:scheduled_weekly) { FactoryGirl.build(:dataset_scheduling, :scheduled_weekly) }
    let(:connection) { double :connection, user: 'joe', password: 'secret', uri: 'empty' }
    let(:user) { User.new(username: 'johndoe') }
    let(:success_result) { double 'result', success?: true }

    context '#create' do
      context 'Dataset is valid' do
        before do
          allow(dataset).to receive(:valid?).and_return true
        end

         it 'creates Middlegate dataset and transformation' do
          described_class.create(
            dataset: dataset,
            scheduling: scheduled_once,
            connection: connection,
            user: user
          )
        end
        
         it 'creates Middlegate dataset with table defined' do
          described_class.create(
            dataset: dataset_with_table,
            scheduling: scheduled_once,
            connection: connection,
            user: user
          )
        end

        it 'creates scheduled jdbc transformation' do
          described_class.create(
            dataset: dataset,
            scheduling: scheduled_weekly,
            connection: connection,
            user: user
          )
        end

      end
    end
  end
end
