# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class DatasetPolicy
  attr_reader :user, :dataset

  def initialize(user, dataset)
    @user = user
    @dataset = dataset
  end

  def owner?
    return false if @user.nil?

    user.id == dataset.owner_id || user.is_admin?
  end

  def admin?
    return false if @user.nil?

    dataset.request_accesses.where(user_id: user.id, role_type: '2').any?
  end

  def user?
    dataset.request_accesses.where(user_id: user.id, role_type: '1').any?
  end

  def can_request_access?
    dataset.request_accesses.where(user_id: user.id).count == 0
  end

  def edit?
    owner? || admin?
  end

  def read?
    owner? || admin? || user? || dataset.public?
  end

  def destroy?
    owner? || admin?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      [scope.joins(:request_accesses).where('request_accesses.user_id' => @user.id, 'request_accesses.status' => 1) + scope.where(owner_id: @user.id)].flatten
    end
  end
end
