# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160802163756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"


  create_table "api_users", force: :cascade do |t|
    t.string   "api_key",      limit: 64
    t.integer  "user_id"
    t.boolean  "write_access"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "columns", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "data_type"
    t.text     "business_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_business_key"
    t.integer  "table_id"
  end

  add_index "columns", ["table_id"], name: "index_columns_on_table_id", using: :btree

  create_table "contributors", force: :cascade do |t|
    t.integer  "dataset_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  create_table "dataset_attributes", force: :cascade do |t|
    t.integer  "dataset_id"
    t.string   "key"
    t.text     "value"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "dataset_attributes", ["dataset_id"], name: "index_dataset_attributes_on_dataset_id", using: :btree

  create_table "dataset_columns", force: :cascade do |t|
    t.integer  "column_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dataset_id"
    t.string   "column_alias"
  end

  create_table "dataset_tags", force: :cascade do |t|
    t.integer  "taggedby_id"
    t.integer  "tag_id"
    t.integer  "dataset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  create_table "datasets", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "terms_of_service_id"
    t.integer  "owner_id"
    t.integer  "subject_area_id"
    t.string   "country_code"
    t.integer  "size",                limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dataset_hash"
    t.integer  "datasource_id"
    t.string   "restricted",                    default: "public"
    t.string   "status",                        default: "unknown"
    t.string   "external_id"
    t.string   "domain"
    t.boolean  "ingested",                      default: false
    t.string   "reference_id"
    t.integer  "notes_count"
    t.string   "url"
    t.decimal  "cost"
    t.integer  "update_frequency"
  end

  create_table "datasources", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "like_activities", force: :cascade do |t|
    t.integer  "dataset_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lineages", force: :cascade do |t|
    t.integer  "child_dataset_id"
    t.integer  "parent_dataset_id"
    t.string   "operation"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "algorithm_id"
  end

  create_table "links", force: :cascade do |t|
    t.string   "url"
    t.string   "name"
    t.string   "description"
    t.integer  "dataset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: :cascade do |t|
    t.text     "body",       null: false
    t.integer  "dataset_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notes", ["dataset_id"], name: "index_notes_on_dataset_id", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "kind"
    t.integer  "endYear"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_accesses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "dataset_id"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "emailed_owner_at"
    t.datetime "emailed_user_at"
    t.integer  "owner_id"
    t.integer  "status",           default: 0
    t.integer  "role_type"
  end

  add_index "request_accesses", ["dataset_id"], name: "index_request_accesses_on_dataset_id", using: :btree
  add_index "request_accesses", ["user_id"], name: "index_request_accesses_on_user_id", using: :btree

  create_table "review_activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "dataset_id"
    t.text     "review"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_activities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "search_terms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "share_activities", force: :cascade do |t|
    t.integer  "dataset_id"
    t.integer  "user_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subject_areas", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tables", force: :cascade do |t|
    t.string   "name"
    t.integer  "dataset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "query"
  end

  add_index "tables", ["dataset_id"], name: "index_tables_on_dataset_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms_acceptances", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "terms_of_use_id"
    t.datetime "accepted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "terms_acceptances", ["accepted_at"], name: "index_terms_acceptances_on_accepted_at", using: :btree
  add_index "terms_acceptances", ["terms_of_use_id"], name: "index_terms_acceptances_on_terms_of_use_id", using: :btree
  add_index "terms_acceptances", ["user_id"], name: "index_terms_acceptances_on_user_id", using: :btree

  create_table "terms_of_services", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms_of_use", force: :cascade do |t|
    t.text     "terms"
    t.date     "valid_from"
    t.date     "valid_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "terms_of_use", ["valid_from"], name: "index_terms_of_use_on_valid_from", using: :btree
  add_index "terms_of_use", ["valid_to"], name: "index_terms_of_use_on_valid_to", using: :btree

  create_table "update_activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "dataset_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_elasticsearch_solutions", force: :cascade do |t|
    t.string   "ip_address"
    t.string   "index_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "host"
    t.string   "external_id"
    t.integer  "port"
  end

  create_table "user_solutions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "user_solutions", ["user_id"], name: "index_user_solutions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login"
    t.boolean  "is_admin"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_active",       default: true
    t.integer  "subject_area_id"
    t.string   "gplus"
    t.string   "image"
  end

  create_table "view_activities", force: :cascade do |t|
    t.integer  "dataset_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "contributors", "datasets"
  add_foreign_key "contributors", "users"
  add_foreign_key "dataset_attributes", "datasets"
  add_foreign_key "dataset_attributes", "users"
  add_foreign_key "dataset_tags", "datasets"
  add_foreign_key "dataset_tags", "tags"
  add_foreign_key "dataset_tags", "users", column: "taggedby_id"
  add_foreign_key "datasets", "datasources"
  add_foreign_key "datasets", "subject_areas"
  add_foreign_key "datasets", "terms_of_services"
  add_foreign_key "datasets", "users", column: "owner_id"
  add_foreign_key "like_activities", "datasets"
  add_foreign_key "like_activities", "users"
  add_foreign_key "lineages", "algorithms"
  add_foreign_key "lineages", "datasets", column: "child_dataset_id"
  add_foreign_key "lineages", "datasets", column: "parent_dataset_id"
  add_foreign_key "newsfeed_items", "datasets"
  add_foreign_key "newsfeed_items", "like_activities"
  add_foreign_key "newsfeed_items", "review_activities"
  add_foreign_key "newsfeed_items", "share_activities"
  add_foreign_key "newsfeed_items", "update_activities"
  add_foreign_key "newsfeed_items", "users"
  add_foreign_key "notes", "datasets"
  add_foreign_key "notes", "users"
  add_foreign_key "review_activities", "datasets"
  add_foreign_key "review_activities", "users"
  add_foreign_key "search_activities", "users"
  add_foreign_key "share_activities", "datasets"
  add_foreign_key "share_activities", "users"
  add_foreign_key "tags", "users", column: "created_by_id"
  add_foreign_key "update_activities", "datasets"
  add_foreign_key "update_activities", "users"
  add_foreign_key "view_activities", "datasets"
  add_foreign_key "view_activities", "users"
end
