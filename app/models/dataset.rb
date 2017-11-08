# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'elasticsearch/model'
require 'securerandom'

# Dataset class is the primary model, related to almost all other models
class Dataset < ActiveRecord::Base
  include ApplicationHelper
  include Searchable

  attr_accessor :last_updated_by,
                :jdbc_driver_id,
                :ingest_download_type,
                :hdfs_folder,
                :db_name,
                :retention_value,
                :retention_unit

  belongs_to :terms_of_service
  belongs_to :subject_area
  belongs_to :owner, class_name: 'User'
  belongs_to :datasource

  has_many :dataset_tags
  has_many :tags, through: :dataset_tags, dependent: :destroy

  has_many :algorithms, through: :dataset_algorithms, dependent: :destroy
  has_many :users, through: :contributors, dependent: :destroy
  has_many :ingest_activities, dependent: :destroy
  has_many :view_activities, dependent: :destroy
  has_many :share_activities, dependent: :destroy
  has_many :review_activities, dependent: :destroy
  has_many :search_activities, foreign_key: 'user_id', dependent: :destroy
  has_many :like_activities, dependent: :destroy
  has_many :request_accesses, dependent: :destroy

  has_many :tables, dependent: :destroy
  has_many :columns, through: :tables
  accepts_nested_attributes_for :tables, allow_destroy: true
  accepts_nested_attributes_for :columns, allow_destroy: true

  has_many :elasticsearch_sources
  has_many :user_elasticsearch_solutions, through: :elasticsearch_sources, dependent: :destroy

  has_many :contributors
  has_many :dataset_algorithms
  has_many :parent_lineages, class_name: 'Lineage', foreign_key: :child_dataset_id, dependent: :destroy
  has_many :child_lineages,  class_name: 'Lineage', foreign_key: :parent_dataset_id, dependent: :destroy
  has_many :dataset_visual_tools, dependent: :destroy
  has_many :dataset_attributes, dependent: :destroy
  has_many :notes, dependent: :destroy

  delegate :full_name, to: :owner, prefix: true, allow_nil: true
  delegate :name, to: :terms_of_service, prefix: true
  delegate :description, to: :terms_of_service, prefix: true
  delegate :name, to: :subject_area, prefix: true, allow_nil: true

  after_initialize :set_datasource

  validates :name, :description, presence: true

  accepts_nested_attributes_for :terms_of_service

  def self.build
    dataset.new
    dataset.tables.build_columns
  end

  def domain
    read_attribute(:domain) || 'SQL'
  end

  def public?
    restricted == 'public'
  end

  def to_lineage_node(lineage_id, operation)
    {
      name: name,
      dataset_id: id,
      operation: operation,
      lineage_id: lineage_id,
      size: size,
      size_formatted: size_formatted,
      owner: owner_full_name,
      datasource: datasource.id
    }
  end

  def owner_upn
    owner.to_upn if owner
  end

  def save_external_id
    self.external_id ||= "hy-#{SecureRandom.hex(18)}"
  end

  def set_datasource
    # method for defaulting the datasource, since the user are not
    # allowed to select it anymore
    self.datasource_id ||= 1
  end

  def terms_of_service_name
    terms_of_service.name if terms_of_service
  end

  def terms_of_service_name=(name)
    if terms_of_service
      terms_of_service.name = name
      terms_of_service.save!
      # else
      #   self.terms_of_service_id = TermsOfService.create(name: name).id
    end
  end

  def country_name
    (ISO3166::Country.find_country_by_alpha2(country_code) || ISO3166::Country.find_country_by_gec(country_code)).try(:name) if country_code
  end

  def update_timestamp
    update_column(:updated_at, Time.now) unless destroyed?
  end

  # we don't need to always put entire set from dataset. So when any relation || country_code was updated, then reindex completely
  def document_change
    changes_made = previous_changes.keys.reject { |c| c == 'updated_at' }.select { |c| c =~ /_(id|at|code)$/ }
    changes_made.empty? ? document_index : document_reindex
  end

  def document_index
    IndexDatasetWorker.perform_async(id) unless destroyed?
  end

  def document_reindex
    ReindexDatasetWorker.perform_async(id) unless destroyed?
  end
end
