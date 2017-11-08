# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe UserElasticsearchSolution do
  describe 'associations' do
    it { should have_one(:user_solution).dependent(:destroy) }
  end

  describe '.human_name' do
    it 'should return the human name of the model' do
      expect(UserElasticsearchSolution.human_name).to eq('Elastic Search')
    end
  end

  describe 'validations' do
    it 'has valid factory' do
      user_elasticsearch_solution = create(:user_elasticsearch_solution)
      expect(user_elasticsearch_solution.valid?).to eq(true)
    end

    it 'validates presence' do
      user_elasticsearch_solution = UserElasticsearchSolution.new
      expect(user_elasticsearch_solution.valid?).to eq(false)
      expect(user_elasticsearch_solution.errors.messages).to eq({:host=>["can't be blank"], :port=>["can't be blank", "is not a number"], :index_name=>["can't be blank"], :ip_address=>["can't be blank", "wrong format of IP address"], :dataset_ids=>["can't be blank"]})
    end

    it 'validates numericality' do
      expect { create(:user_elasticsearch_solution, port: 'not a number') }.to raise_exception(ActiveRecord::RecordInvalid)
      expect { create(:user_elasticsearch_solution, port: '-432') }.to raise_exception(ActiveRecord::RecordInvalid)
    end

    it 'validates ip address' do
      expect { create(:user_elasticsearch_solution, ip_address: '1.1.wrong') }.to raise_exception(ActiveRecord::RecordInvalid)
      expect { create(:user_elasticsearch_solution, ip_address: '192.128.0.12') }.not_to raise_exception(ActiveRecord::RecordInvalid)
    end
  end
end
