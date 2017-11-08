# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class UserPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  class Scope
    attr_reader :dataset, :scope

    def initialize(dataset, scope)
      @dataset = dataset
      @scope = scope
    end

    def resolve
      scope.joins(:request_accesses)
        .where(request_accesses: { dataset_id: dataset.id, status: '1' })
    end
  end
end
