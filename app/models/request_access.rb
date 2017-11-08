# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class RequestAccess < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :dataset

  enum status: [:waiting, :approved, :rejected]
  enum role_type: [:pending, :user, :admin]

  delegate :owner, to: :dataset
  delegate :email, to: :owner, prefix: true
  delegate :username, to: :owner, prefix: true
  delegate :email, to: :user, prefix: 'applicant'
  delegate :full_name, to: :user, prefix: 'applicant'
  delegate :username, to: :user, prefix: 'applicant'
  delegate :name, to: :dataset, prefix: true
  delegate :owner_id, to: :dataset
  delegate :owner_name, to: :dataset

  def to_param
    { id: dataset.id, request_access_id: id }
  end
end
