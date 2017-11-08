# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class DatasetAttribute < ActiveRecord::Base
  belongs_to :dataset
  belongs_to :user

  validates :key, uniqueness: { scope: :dataset_id, case_sensitive: false }, presence: true
  validates :dataset_id, presence: true

  after_commit :reindex_references

  scope :ordered, -> { order(key: :asc) }

  def value_url?
    value =~ /\Ahttp[s]?:\/\//i
  end

  def self.autocomplete(options = {})
    except = Array.wrap(options.fetch(:except, nil))
    query = options.fetch(:query, '')
    keys = where(dataset_id: except).pluck(:key) if except.present?
    where('key ilike ?', "%#{query}%").where.not(key: keys).pluck(:key).uniq.sort
  end

  private

  def reindex_references
    dataset.update_timestamp
    dataset.document_reindex
  end
end
