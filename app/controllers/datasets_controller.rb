# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class DatasetsController < ApplicationController
  before_action :set_dataset,
                only: [:show, :like, :share, :edit, :explore_lineage,
                       :lineage_dataset_details, :update, :destroy, :update_tags]

  before_action :ensure_dataset_owner, only: [:destroy]
  before_action :ensure_dataset_admin, only: [:edit, :update]

  MAX_RESULTS = 5 # max number of behavioral dataset results to find

  def new
    @dataset = Dataset.build
    @table = @dataset.tables.find(params[:id])
    @column = @table.columns.new
  end

  def create
    @dataset = Dataset.new(dataset_params)
    @dataset.save
  end

  def show
    @max_depth = 2

    @parent_lineages = {}
    build_parent_lineages(@parent_lineages, @dataset)

    @child_lineages = {}
    build_child_lineages(@child_lineages, @dataset)

    @immediate_parent_linages = @parent_lineages.deep_dup
    @immediate_parent_linages[:children].each do |c|
      c.delete(:children)
    end if @immediate_parent_linages[:children]

    @immediate_child_lineages = @child_lineages.deep_dup
    @immediate_child_lineages[:children].each do |c|
      c.delete(:children)
    end if @immediate_child_lineages[:children]

    set_same_x

    @related_datasets, @relations, @columns = build_relations(@dataset)

    @related_datasets.each do |d|
      d[:relations] = @relations.select { |r| r[:source] == d[:id] }.collect { |r| r[:target] }
    end

    @columns.each do |c|
      c[:relations] = @relations.select { |r| r[:target] == c[:id] }.collect { |r| r[:source] }
    end

    if logged_in?
      @request_access = @dataset.request_accesses.find_by(user_id: current_user) || @dataset.request_accesses.build(user_id: current_user.id)
    else
      @request_accesses = false
    end

    @note = Note.new
    @table = Table.new
    @column = Column.new
  end

  def explore_lineage
    @max_depth = 2

    @parent_lineages = {}
    build_parent_lineages(@parent_lineages, @dataset)

    @child_lineages = {}
    build_child_lineages(@child_lineages, @dataset)

    render json: { parent_lineages: @parent_lineages, child_lineages: @child_lineages }
  end

  def lineage_dataset_details
    render partial: 'dataset_details'
  end

  def like
    like_activity = LikeActivity.where(user: current_user, dataset: @dataset).first

    if like_activity
      like_activity.destroy
      flash[:info] = "Unliked #{@dataset.name}."
    else
      LikeActivity.create(user: current_user, dataset: @dataset)
      flash[:info] = "Liked #{@dataset.name}."
    end

    redirect_to @dataset
  end

  def access_help_text
    policy = DatasetPolicy.new(current_user, @dataset)

    if policy.owner?
      if @dataset.public?
        "<span>Public access:</span> Anyone within Linea is able
         to access data in this dataset"
      else
        "<span>Managed access:</span> Anyone within Linea will be able to see dataset
         description and ask for access to data. You will manage these requests."
      end

    elsif policy.admin?
      "<span>You can edit this dataset:</span> You can edit transformation,
       see their statuses and logs, edit description, etc."
    else
      if @dataset.public? || policy.user?
        "<span>You can access all data.</span> If you need to modify data,
         the owner can grant modification rights to you. Write him."
      else
        "Dataset owner needs to confirm your access.
         We’ll notify you once that happens by e-mail."
      end
    end
  end

  helper_method :access_help_text

  def share
    ShareActivity.create(user: current_user, dataset: @dataset)

    flash[:info] = "#{@dataset.name} shared with your colleagues."

    redirect_to @dataset
  end

  def update_tags
    @dataset.dataset_tags.where(id: params[:dataset_tags_to_remove]).each(&:destroy) if params[:dataset_tags_to_remove].present?

    if params[:tags_to_add].present?
      params[:tags_to_add].each do |t|
        next if @dataset.tags.exists?(name: t.downcase)
        tag = Tag.find_or_create_by(name: t.downcase)
        @dataset.tags << tag
      end
    end

    render json: { status: 'OK' }
  end

  def redisplay_columns
    @dataset = set_dataset
    respond_to do |format|
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dataset
    @dataset = Dataset.find(params[:id])
  end

  # Set a variable showing datasets using the 'same algorithm as' this dataset.
  def set_same_algorithm
    @same_algorithm = Dataset.joins(:algorithms)
                      .where(algorithms: { id: @dataset.algorithm_ids })
                      .where.not(id: @dataset.id).uniq.limit(MAX_RESULTS)
  end

  # Set a variable showing datasets that have the 'same owner as' this dataset.
  def set_same_owner
    @same_owner = Dataset.where(owner_id: @dataset.owner_id)
                  .where.not(id: @dataset.id).uniq.limit(MAX_RESULTS)
  end

  # Set a variable showing datasets that have some of the 'same tags as' this dataset.
  def set_same_tags
    @same_tags = Dataset.select('datasets.*, count(tags) AS tag_count').joins(:tags)
                 .where(tags: { id: @dataset.tags.ids }).where.not(id: @dataset.id)
                 .uniq.group('datasets.id').order('tag_count DESC').limit(MAX_RESULTS)
  end

  # Set a variable showing datasets that have the 'same owner as' this dataset.
  def set_same_source
    @same_source = Dataset.where(datasource_id: @dataset.datasource.id)
                   .where.not(id: @dataset.id).uniq.limit(MAX_RESULTS)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dataset_params
    params.require(:dataset).permit(:name, :description, :terms_of_service_id,
                                    :owner_id, :subject_area_id, :country_code,
                                    :datasource_id, :size, tag_ids: [], algorithm_ids: [], tables_attributes: [:id, :name, columns_attributes: [:id, :name, :description, :data_type, :business_name, :is_business_key, :table_id]])
  end

  # Builds a list of parent lineages from the dataset, extending out 'cur_depth' parents.
  def build_parent_lineages(node, dataset, lineage_id = 0, operation = 'root', cur_depth = 0)
    if dataset.parent_lineages.nil? || dataset.parent_lineages.count == 0 || cur_depth == @max_depth
      node.merge!(dataset.to_lineage_node(lineage_id, operation))
      return node
    else
      node.merge!(dataset.to_lineage_node(lineage_id, operation))
      node[:children] = []
      dataset.parent_lineages.each do |l|
        node[:children] << build_parent_lineages({}, l.parent_dataset, l.id, l.operation, (cur_depth + 1))
      end
      return node
    end
  end

  # Builds a list of child lineages from the dataset, extending out 'cur_depth' parents.
  def build_child_lineages(node, dataset, lineage_id = 0, operation = 'root', cur_depth = 0)
    if dataset.child_lineages.nil? || dataset.child_lineages.count == 0 || cur_depth == @max_depth
      node.merge!(dataset.to_lineage_node(lineage_id, operation))
      return node
    else
      node.merge!(dataset.to_lineage_node(lineage_id, operation))
      node[:children] = []
      dataset.child_lineages.each do |l|
        node[:children] << build_child_lineages({}, l.child_dataset, l.id, l.operation, (cur_depth + 1))
      end
      return node
    end
  end

  def build_relations(dataset, _current_depth = 0)
    related_datasets = [{ id: dataset.id, name: dataset.name, weight: 1 }]
    relations = []
    columns = []

    column_id = 1

    dataset.columns.each do |c|
      next unless c.is_business_key

      datasets_with_shared_column = Dataset.joins(:columns)
                                    .where(columns: { business_name: c.business_name, is_business_key: true}).all

      columns << { id: column_id, name: c.name }
      datasets_with_shared_column.each do |r|
        relations << { source: r.id, target: column_id }
      end

      related_datasets << datasets_with_shared_column.collect { |d| { id: d.id, name: d.name, weight: 1 } }

      column_id += 1
    end

    [related_datasets.flatten.uniq, relations.uniq, columns.uniq]
  end

  def set_same_x
    set_same_algorithm
    set_same_owner
    set_same_source
    set_same_tags
  end

  def ensure_dataset_owner
    unless DatasetPolicy.new(current_user, @dataset).owner?
      fail t 'dataset_policy.owner?', scope: 'pundit'
    end
  end

  def ensure_dataset_admin
    unless DatasetPolicy.new(current_user, @dataset).admin? || DatasetPolicy.new(current_user, @dataset).owner?
      fail t 'dataset_policy.owner?', scope: 'pundit'
    end
  end
end
