# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true

  has_many :ingest_activities
  has_many :view_activities
  has_many :search_activities
  has_many :share_activities
  has_many :review_activities
  has_many :request_accesses
  has_many :user_solutions
  has_many :notes, dependent: :destroy

  after_save :reindex_references

  has_many :owned_datasets, class_name: 'Dataset', foreign_key: 'owner_id'
  has_many :user_elasticsearch_solutions, foreign_key: 'owner_id'

  has_many :terms_acceptances
  has_many :terms_of_use, through: :terms_acceptances

  has_one :api_user

  def api_access?
    api_user.present?
  end

  def admin?
    is_admin
  end

  def to_upn
    return nil if username.nil?
    username_without_domain = username.split('\\').last
    "#{username_without_domain}@Company.COM" #place your company email setup here
  end

  def accepted_latest_terms_of_use?
    return false unless terms_acceptances.present?
    terms_acceptances.last.latest_accepted?
  end

  def avatar_path
    'default_profile_photo.jpg'
  end

  def self.authenticate(auth)
    email = auth.info.email
    u = User.find_or_create_by(email: email).tap do |user|
      user.username = email
      user.full_name = auth.info.name
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.is_admin = false
    end
    u.save
    u.touch(:last_login) unless u.new_record?
    u
  end

  def self.find_or_create_user_from_iam_profile_by_username(username, data)
    u = User.find_or_create_by(username: username).tap do |user|
      user.full_name = data.profile.full_name
      user.first_name = data.profile.first_name
      user.last_name = data.profile.last_name
      user.email = data.profile.email
    end
    u.save
    u
  end

  private

  def reindex_references
    owned_datasets.each(&:document_index)
  end
end
