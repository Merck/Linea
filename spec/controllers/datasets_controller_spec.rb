# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe DatasetsController, type: :controller do
  let(:current_user) { create :admin_user }
  before { session[:user_id] = current_user.id }

  describe 'GET show' do
    let(:dataset) { create :dataset }

    it 'assigns @dataset' do
      get :show, id: dataset.id

      expect(assigns(:dataset)).to eq(dataset)
    end

    context 'if there are no parent lineages' do
      it 'assigns @parent_lineages with one root node' do
        generator = DatasetsParentsHierarchyGenerator.new(max_depth: 2)

        get :show, id: dataset.id

        expect(
          assigns(:parent_lineages)
        ).to eq(
          generator.generate(dataset: dataset)
        )
      end

      it 'assigns @immediate_parent_linages with one root node' do
        generator = DatasetsParentsHierarchyGenerator.new(max_depth: 1)

        get :show, id: dataset.id

        expect(
          assigns(:immediate_parent_linages)
        ).to  eq(
          generator.generate(dataset: dataset)
        )
      end
    end

    context 'if there is a parent lineage' do
      let(:datasets_chain) { generate_datasets_chain(3) }
      let(:dataset_from_chain) { datasets_chain[1] }

      it 'assigns @parent_lineages with the root and one child node' do
        generator = DatasetsParentsHierarchyGenerator.new(max_depth: 2)

        get :show, id: dataset_from_chain.id

        expect(
          assigns(:parent_lineages)
        ).to eq(
          generator.generate(dataset: dataset_from_chain)
        )
      end

      it 'assigns @immediate_parent_linages with the root and one child node' do
        generator = DatasetsParentsHierarchyGenerator.new(max_depth: 1)

        get :show, id: dataset_from_chain.id

        expect(
          assigns(:immediate_parent_linages)
        ).to eq(
          generator.generate(dataset: dataset_from_chain)
        )
      end
    end

    context 'if there are more than two parent lineages' do
      let(:datasets_chain) { generate_datasets_chain(5) }
      let(:dataset_from_chain) { datasets_chain[1] }

      it 'assigns @parent_lineages with the root node and just two child nodes' do
        generator = DatasetsParentsHierarchyGenerator.new(max_depth: 2)

        get :show, id: dataset_from_chain.id

        expect(
          assigns(:parent_lineages)
        ).to  eq(
          generator.generate(dataset: dataset_from_chain)
        )
      end

      it 'assigns @immediate_parent_linages with the root and one child node' do
        generator = DatasetsParentsHierarchyGenerator.new(max_depth: 1)

        get :show, id: dataset_from_chain.id

        expect(
          assigns(:immediate_parent_linages)
        ).to eq(
          generator.generate(dataset: dataset_from_chain)
        )
      end
    end

    context 'if there are no child lineages' do
      let(:datasets_chain) { generate_datasets_chain(5) }
      let(:dataset_from_chain) { datasets_chain[1] }

      it 'assigns @child_lineages with one root node' do
        generator = DatasetsChildrenHierarcyGenerator.new(max_depth: 2)

        get :show, id: dataset_from_chain.id

        expect(assigns(:child_lineages)).to eq(
          generator.generate(dataset: dataset_from_chain)
        )
      end

      it 'assigns @immediate_child_lineages with one root node' do
        generator = DatasetsChildrenHierarcyGenerator.new(max_depth: 1)

        get :show, id: dataset_from_chain.id

        expect(
          assigns(:immediate_child_lineages)
        ).to eq(
          generator.generate(dataset: dataset_from_chain)
        )
      end
    end

    context 'if there is a child lineage' do
      let(:datasets_chain) { generate_datasets_chain(5) }
      let(:dataset_from_chain) { datasets_chain[1] }
      let(:dataset) { create :dataset }

      it 'assigns @child_lineages with the root and one child node' do
        generator = DatasetsChildrenHierarcyGenerator.new(max_depth: 2)

        get :show, id: dataset_from_chain.id

        expect(assigns(:child_lineages)).to eq(
          generator.generate(dataset: dataset_from_chain)
        )
      end

      it 'assigns @immediate_child_lineages with the root and one child node' do
        generator = DatasetsChildrenHierarcyGenerator.new(max_depth: 1)

        get :show, id: dataset_from_chain.id

        expect(assigns(:immediate_child_lineages)).to eq(
          generator.generate(dataset: dataset_from_chain)
        )
      end
    end

    context 'if there are more than two child lineages' do
      let(:datasets_chain) { generate_datasets_chain(5) }
      let(:dataset_from_chain) { datasets_chain[3] }

      it 'assigns @child_lineages with the root node and just two child nodes' do
        generator = DatasetsChildrenHierarcyGenerator.new(max_depth: 2)

        get :show, id: dataset_from_chain.id

        expect(assigns(:child_lineages)).to eq(
          generator.generate(dataset: dataset_from_chain)
        )
      end

      it 'assigns @immediate_child_lineages with the root and one child node' do
        generator = DatasetsChildrenHierarcyGenerator.new(max_depth: 1)

        get :show, id: dataset_from_chain.id

        expect(assigns(:immediate_child_lineages)).to eq(
          generator.generate(dataset: dataset_from_chain)
        )
      end
    end

    it 'assigns 5 datasets with the same algorithm to @same_algorithm' do
      algorithm = create(:algorithm)
      datasets = create_list(:dataset, 7)
      datasets.each do |dataset|
        create(:dataset_algorithm, dataset: dataset, algorithm: algorithm)
      end

      get :show, id: datasets.first.id

      assigned_datasets = assigns(:same_algorithm)
      expect(assigned_datasets.size).to eq(5)
      expect(datasets).to include(*assigned_datasets)
    end

    it 'assigns 5 datasets with the same owner to @same_owner' do
      owner = create(:user)
      datasets = create_list(:dataset, 7, owner: owner)

      get :show, id: datasets.first.id

      assigned_datasets = assigns(:same_owner)
      expect(assigned_datasets.size).to eq(5)
      expect(datasets).to include(*assigned_datasets)
    end

    it 'assigns 5 datasets with the same datasource to @same_source' do
      datasource = create(:datasource)
      datasets = create_list(:dataset, 7, datasource: datasource)

      get :show, id: datasets.first.id

      assigned_datasets = assigns(:same_source)
      expect(assigned_datasets.size).to eq(5)
      expect(datasets).to include(*(assigned_datasets))
    end

    it 'assigns 5 datasets with the same tags to @same_tags' do
      tags = [create(:tag, name: 'tag1'), create(:tag, name: 'tag2')]
      datasets = create_list(:dataset, 7)
      datasets.each do |dataset|
        tags.each { |tag| create(:dataset_tag, dataset: dataset, tag: tag) }
      end

      get :show, id: datasets.first.id

      expect(assigns(:same_tags)).to eq(datasets[1..5])
    end

    it 'assigns related datasets to @related_datasets' do
      create(:table, dataset: dataset, columns: [
        create(:column, is_business_key: true,  business_name: 'col1'),
        create(:column, is_business_key: true,  business_name: 'col2'),
        create(:column, is_business_key: false, business_name: 'col3')
      ])
      related_dataset = create(:dataset)
      create(:table, dataset: related_dataset, columns: [
        create(:column, is_business_key: false, business_name: 'col1'),
        create(:column, is_business_key: true,  business_name: 'col1'),
        create(:column, is_business_key: true,  business_name: 'col2'),
        create(:column, is_business_key: true,  business_name: 'col3')
      ])

      get :show, id: dataset.id

      expect(assigns(:related_datasets)).to include(
        {
          id: dataset.id,
          name: dataset.name,
          weight: 1,
          relations: [1, 2]
        },           id: related_dataset.id,
                     name: related_dataset.name,
                     weight: 1,
                     relations: [1, 2]
      )
    end

    it 'assigns relations to @relations' do
      create(:table, dataset: dataset, columns: [
        create(:column, is_business_key: true,  business_name: 'col1'),
        create(:column, is_business_key: true,  business_name: 'col2'),
        create(:column, is_business_key: false, business_name: 'col3')
      ])
      related_dataset = create(:dataset)
      create(:table, dataset: related_dataset, columns: [
        create(:column, is_business_key: false, business_name: 'col1'),
        create(:column, is_business_key: true,  business_name: 'col1'),
        create(:column, is_business_key: true,  business_name: 'col2'),
        create(:column, is_business_key: true,  business_name: 'col3')
      ])

      get :show, id: dataset.id

      expect(assigns(:relations)).to include(
        { source: dataset.id,         target: 1 },
        { source: related_dataset.id, target: 1 },
        { source: dataset.id,         target: 2 },
        source: related_dataset.id, target: 2
      )
    end

    it 'assigns all participating columns to @columns' do
      create(:table, dataset: dataset, columns: [
        create(:column, is_business_key: true,  business_name: 'col1'),
        create(:column, is_business_key: true,  business_name: 'col2'),
        create(:column, is_business_key: false, business_name: 'col3')
      ])
      related_dataset = create(:dataset)
      create(:table, dataset: related_dataset, columns: [
        create(:column, is_business_key: false, business_name: 'col1'),
        create(:column, is_business_key: true,  business_name: 'col1'),
        create(:column, is_business_key: true,  business_name: 'col2'),
        create(:column, is_business_key: true,  business_name: 'col3')
      ])

      get :show, id: dataset.id

      cols = assigns(:columns)
      expect(cols.size).to eq(2)
      first_col = cols[0]
      expect(first_col).to include(id: 1)
      expect(first_col[:relations]).to include(dataset.id, related_dataset.id)
      second_col = cols[1]
      expect(second_col).to include(id: 2)
      expect(second_col[:relations]).to include(dataset.id, related_dataset.id)
      expect(%w(col1 col2)).to include(cols[0][:name])
      expect(%w(col1 col2)).to include(cols[1][:name])
    end

    it 'assigns @request_access' do
      get :show, id: dataset.id

      request_access = assigns(:request_access)
      expect(request_access).to be_a_new(RequestAccess)
      expect(request_access.dataset_id).to eq(dataset.id)
    end
  end

  describe 'GET explore_lineage' do
    let(:dataset) { create :dataset }

    it 'assigns @dataset' do
      get :explore_lineage, id: dataset.id
      expect(assigns(:dataset)).to eq(dataset)
    end

    it 'assigns @parent_lineages' do
      datasets_chain = generate_datasets_chain(5)
      dataset = datasets_chain[1]
      generator = DatasetsParentsHierarchyGenerator.new(max_depth: 2)

      get :explore_lineage, id: dataset.id

      expect(assigns(:parent_lineages)).to eq(
        generator.generate(dataset: dataset)
      )
    end

    it 'assigns @child_lineages' do
      get :explore_lineage, id: dataset.id

      generator = DatasetsParentsHierarchyGenerator.new(max_depth: 2)
      expect(assigns(:parent_lineages)).to eq(
        generator.generate(dataset: dataset)
      )
    end
  end

  describe 'GET lineage_dataset_details' do
    let(:dataset) { create :dataset }

    it 'assigns @dataset' do
      get :lineage_dataset_details, id: dataset.id
      expect(assigns(:dataset)).to eq(dataset)
    end

    it 'renders dataset_details template' do
      get :lineage_dataset_details, id: dataset.id
      expect(response).to render_template('datasets/_dataset_details')
    end
  end

  describe 'GET like' do
    let(:dataset) { create :dataset }

    it 'assigns @dataset' do
      get :like, id: dataset.id
      expect(assigns(:dataset)).to eq(dataset)
    end

    context 'if the dataset is already liked by the current user' do
      it 'destroys the like_activity' do
        like_activity = create(:like_activity, user: current_user, dataset: dataset)

        get :like, id: dataset.id
        expect(LikeActivity.exists?(like_activity.id)).to be(false)
      end

      it 'shows "unliked" flash message' do
        create(:like_activity, user: current_user, dataset: dataset)
        get :like, id: dataset.id
        expect(flash[:info]).to eq("Unliked #{dataset.name}.")
      end

      it 'redirects to "show" action' do
        get :like, id: dataset.id
        expect(response).to redirect_to(action: :show, id: dataset.id)
      end
    end

    context 'if the dataset is not liked by the current user' do
      it 'creates the like activity' do
        get :like, id: dataset.id
        expect(LikeActivity.exists?(user: current_user, dataset: dataset)).to \
          be(true)
      end

      it 'shows "liked" flash message' do
        get :like, id: dataset.id
        expect(flash[:info]).to eq("Liked #{dataset.name}.")
      end

      it 'redirects to "show" action' do
        get :like, id: dataset.id
        expect(response).to redirect_to(action: :show, id: dataset.id)
      end
    end
  end

  describe 'GET share' do
    let(:dataset) { create :dataset }

    it 'assigns @dataset' do
      get :share, id: dataset.id
      expect(assigns(:dataset)).to eq(dataset)
    end

    it 'creates the share activity' do
      get :share, id: dataset.id
      expect(ShareActivity.exists?(user: current_user, dataset: dataset)).to \
        be(true)
    end

    it 'shows "shared" flash message' do
      get :share, id: dataset.id
      expect(flash[:info]).to eq("#{dataset.name} shared with your colleagues.")
    end

    it 'redirects to "show" action' do
      get :share, id: dataset.id
      expect(response).to redirect_to(action: :show, id: dataset.id)
    end
  end

  describe 'POST update_tags' do
    let(:dataset_tag_to_remove) { create(:dataset_tag) }
    let(:existing_tag) { create(:tag, name: 'existing_tag') }
    let(:dataset) { create(:dataset, tags: [existing_tag], dataset_tags: [dataset_tag_to_remove]) }

    it 'removes existing dataset_tag and adds new' do
      post :update_tags,
           id: dataset.id,
           dataset_tags_to_remove: [dataset_tag_to_remove.id],
           tags_to_add: %w(existing_tag NEW_TAG)

      expect(dataset.reload.tags.map(&:name)).to eq(%w(existing_tag new_tag))
      expect(DatasetTag.exists?(dataset_tag_to_remove.id)).to be false
      expect(response).to have_http_status(:ok)
    end
  end

  class DatasetsHierarchyGeneratorBase
    def initialize(max_depth:)
      @max_depth = max_depth
    end

    def generate(dataset:, prev_lineage: nil, recursion_depth: 0)
      dataset_to_node_hash(dataset, prev_lineage).tap do |node_hash|
        return node_hash if recursion_depth == @max_depth
        fetch_lineages(dataset).each do |lineage|
          children = node_hash[:children] ||= []
          children << generate(dataset: get_dataset(lineage),
                               prev_lineage: lineage,
                               recursion_depth: recursion_depth + 1)
        end
      end
    end

    private

    def fetch_lineages
      fail NotImplementedError, 'Subclass must redefine this method.'
    end

    def fetch_dataset
      fail NotImplementedError, 'Subclass must redefine this method.'
    end

    def dataset_to_node_hash(dataset, lineage)
      {
        name: dataset.name,
        dataset_id: dataset.id,
        operation: lineage.try(:operation) || 'root',
        lineage_id: lineage.try(:id) || 0,
        size: dataset.size,
        size_formatted: dataset.size_formatted,
        owner: dataset.owner.full_name,
        datasource: dataset.datasource.id
      }
    end
  end

  class DatasetsParentsHierarchyGenerator < DatasetsHierarchyGeneratorBase
    def fetch_lineages(dataset)
      dataset.parent_lineages
    end

    def get_dataset(lineage)
      lineage.parent_dataset
    end
  end

  class DatasetsChildrenHierarcyGenerator < DatasetsHierarchyGeneratorBase
    def fetch_lineages(dataset)
      dataset.child_lineages
    end

    def get_dataset(lineage)
      lineage.child_dataset
    end
  end

  # First is a child of second, etc.
  def generate_datasets_chain(nodes_count)
    datasets = create_list(:dataset, nodes_count)
    datasets[0..-2].zip(datasets[1..-1]).each do |child, parent|
      create(:lineage,
             child_dataset_id: child.id,
             parent_dataset_id: parent.id,
             operation: "Operation_#{child.id}_#{parent.id}")
    end

    datasets
  end
end
