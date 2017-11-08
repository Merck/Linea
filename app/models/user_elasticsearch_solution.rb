# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'securerandom'
require 'ipaddress'

class UserElasticsearchSolution < ActiveRecord::Base
  has_one :user_solution, as: :middlegate_serviceable, dependent: :destroy
  has_many :datasets, through: :elasticsearch_sources
  has_many :elasticsearch_sources
  delegate :user, to: :user_solution

  after_initialize :save_external_id

  validates :host, :port, :index_name, :ip_address, :dataset_ids, presence: true
  validates :port, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :ip_address_format

  def ip_address_format
    unless IPAddress.valid?(ip_address)
      errors.add(:ip_address, 'wrong format of IP address')
    end
  end

  def self.human_name
    'Elastic Search'
  end

  def save_external_id
    if read_attribute(:external_id).nil?
      self.external_id = "wf_user_elasticsearch_solution_#{SecureRandom.hex}"
    end
    true
  end
end
