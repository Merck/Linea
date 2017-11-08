# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class Tag < ActiveRecord::Base
  default_scope { order(:name) }

  has_many :dataset_tags
  has_many :datasets, through: :dataset_tags

  belongs_to :created_by, class_name: 'User'

  delegate :full_name, to: :created_by, prefix: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.proceed_tags(tag_ids)
    ids = []
    tag_ids.reject(&:blank?).each do |t|
      if Tag.find_by_id(t)
        ids << t
        next
      end
      created_tag = Tag.find_or_create_by(name: t)
      ids << created_tag.id if created_tag.valid?
    end
    ids
  end

  def name
    attributes['name'].downcase if attributes['name']
  end
end
