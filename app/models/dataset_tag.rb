# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class DatasetTag < ActiveRecord::Base
  belongs_to :taggedby, class_name: 'User'
  belongs_to :dataset
  belongs_to :tag

  after_commit :reindex_references, on: [:create, :destroy]

  validates :dataset, presence: true
  validates :tag, presence: true
  validates :tag_id, uniqueness: { scope: :dataset_id, case_sensitive: false }

  # as dependent: destroy doesn't work, we need this (probably due to PG constraints)
  def destroy
    super
    tag.destroy if (tag.dataset_tags.ids - [id]).count == 0
  end

  private

  def reindex_references
    dataset.update_timestamp
    dataset.document_reindex
  end
end
