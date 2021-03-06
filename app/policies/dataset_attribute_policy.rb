# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class DatasetAttributePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def owner?
    return false if @user.nil?
    [record.user_id, record.dataset.owner_id].include?(user.id)
  end

  def update?
    create?
  end

  def new?
    return false if @user.nil?
    record.dataset.owner_id == user.id
  end

  def create?
    new?
  end

  def edit?
    owner?
  end

  def destroy?
    owner?
  end
end
