# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe NewsfeedItem do
  describe 'associations' do
    it { should belong_to(:like_activity) }
    it { should belong_to(:share_activity) }
    it { should belong_to(:review_activity) }
    it { should belong_to(:ingest_activity) }
    it { should belong_to(:update_activity) }
    it { should belong_to(:dataset) }
    it { should belong_to(:user) }
  end
end
