# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe 'Routes for DatasetAttributes', type: :routing do

  it 'does not route index' do
    expect(get: '/datasets/1/attributes').to route_to( { controller: "application", action: "routing_error", path: "datasets/1/attributes" } )
  end

  it 'does not route show' do
    expect(get: '/datasets/1/attributes/2').to route_to( { controller: "application", action: "routing_error", path: "datasets/1/attributes/2" } )
  end

  it 'does route new' do
    expect(get: '/datasets/1/attributes/new').to be_routable
  end

  it 'does route create' do
    expect(post: '/datasets/1/attributes').to be_routable
  end

  it 'does route edit' do
    expect(get: '/datasets/1/attributes/2/edit').to be_routable
  end

  it 'does route delete' do
    expect(delete: '/datasets/1/attributes/2').to be_routable
  end

end
