# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe Dataset do
  describe 'associations' do
    it { should belong_to(:terms_of_service) }
    it { should belong_to(:subject_area) }
    it { should belong_to(:owner) }
    it { should belong_to(:datasource) }

    it { should have_many(:tags) }
    it { should have_many(:algorithms) }
    it { should have_many(:users) }
    it { should have_many(:dataset_tags) }
    it { should have_many(:columns) }
    it { should have_many(:contributors) }
    it { should have_many(:dataset_algorithms) }
    it { should have_many(:parent_lineages) }
    it { should have_many(:child_lineages) }
    it { should have_many(:dataset_visual_tools) }
    it { should have_many(:ingest_activities) }
    it { should have_many(:view_activities) }
    it { should have_many(:share_activities) }
    it { should have_many(:review_activities) }
    it { should have_many(:search_activities) }
    it { should have_many(:like_activities) }
    it { should have_many(:tables) }
    it { should have_many(:columns) }
    it { should have_many(:notes) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  it 'sets correct ElasticSearch mappings' do
    expect(Dataset.mappings.to_hash).to eq(
      dataset: {
        dynamic: "true",
        _all: {
          enabled: "false"
        },
        properties: {
          name: {
            type: "multi_field",
            fields: {
              name: {
                type: "string",
                analyzer: "english"
              },
              shingles: {
                type: "string",
                analyzer: "custom_shingle_analyzer"
              }
            }
          },
          description: {
            type: "string",
            analyzer: "english"
          },
          subject_area: {
            type: "object",
            properties: {
              id: {
                index: :not_analyzed,
                type: "string"
              }
            }
          },
          tags: {
            type: "object",
            properties: {
              id: {
                index: :not_analyzed,
                type: "string"
              }
            }
          },
          owner: {
            type: "object",
            properties: {
              id: {
                index: :not_analyzed,
                type: "string"
              }
            }
          },
          datasource: {
            type: "object",
            properties: {
              id: {
                index: :not_analyzed,
                type: "string"
              }
            }
          },
          country_code: {
            index: :not_analyzed,
            type: "string"
          },
          country_name: {
            type: "string",
            analyzer: "english"
          },
          dataset_attributes: {
            type: "object",
            properties: {
              id: {
                type: "long",
                index: :not_analyzed
              },
              key: {
                type: "string"
              },
              value: {
                type: "string",
                analyzer: "english"
              },
              comment: {
                type: "string",
                analyzer: "english"
              }
            }
          },
          name_autocomplete: {
            type: "completion",
            payloads: true
          },
          owner_full_name_autocomplete: {
            type: "completion",
            payloads: true
          },
          tag_autocomplete: {
            type: "completion",
            payloads: true
          }
        }
      }
    )
  end

  describe 'public?' do
    it 'indicates if dataset is public' do
      expect(build(:dataset, restricted: 'public').public?).to be true
      expect(build(:dataset, restricted: 'private').public?).to be false
      expect(build(:dataset, restricted: '').public?).to be false
    end
  end

  describe 'as_indexed_json' do
    it 'serializes dataset for indexing by ElasticSearch' do
      owner = create(:user, full_name: 'John Doe')
      subject_area = create(:subject_area)
      tag = create(:tag, name: 'Some Tag')
      dataset_attributes = create(:dataset_attribute)
      datasource = create(:datasource)

      user = create(:user)
      contributor = create(:contributor, user: user)

      column = create(:column)
      table = create(:table, columns: [column])

      dataset = create(:dataset,
                       name: 'Some Name',
                       owner: owner,
                       subject_area: subject_area,
                       tags: [tag],
                       dataset_attributes: [dataset_attributes],
                       tables: [table],
                       contributors: [contributor],
                       datasource: datasource,
                       country_code: 'AQ')

      dataset.columns.reload
      expect(dataset.as_indexed_json).to eq(
        'name' => 'Some Name',
        'description' => dataset.description,
        'country_code' => dataset.country_code,
        'created_at' => dataset.created_at,
        'updated_at' => dataset.updated_at,
        'owner' => { 'id' => owner.id, 'full_name' => 'John Doe' },
        'subject_area' => { 'id' => subject_area.id, 'name' => subject_area.name },
        'tags' => [{ 'id' => tag.id, 'name' => 'some tag' }],
        'dataset_attributes' => [{  'id' => dataset_attributes.id, 'key' => dataset_attributes.key, 'value' => dataset_attributes.value, 'comment' => dataset_attributes.comment }],
        'tables' => [{ 'name' => table.name }],
        'columns' => [{
          'name' => column.name,
          'business_name' => column.business_name
        }],
        # FIXME: see Dataset#owner_include method for the problem description.
        'contributors' => [{}],
        'datasource' => { 'id' => datasource.id, 'name' => datasource.name },
        name_autocomplete: {
          input: ['Some Name', 'Some', 'Name'],
          output: 'some name'
        },
        owner_full_name_autocomplete: {
          input: ['John Doe', 'John', 'Doe'],
          output: 'john doe'
        },
        tag_autocomplete: [{
          input: ['some tag', 'some', 'tag'],
          output: 'some tag'
        }],
        country_name: 'Antarctica'
      )
    end
  end

  describe 'removal including associated tables and columns' do
    let(:dataset) { create :dataset, :with_table }

    before { dataset.reload }

    it 'removes the dataset' do
      expect(Dataset.count).to eq 1
      expect(Table.count).to eq 2
      expect(Column.count).to eq 4
    end

    describe 'removing from database' do

      it 'was removed from dataset' do
        expect{ dataset.destroy }.to change(Dataset, :count).by(-1)
      end

      it 'was removed from Table' do
        expect{ dataset.destroy }.to change(Table, :count).by(-2)
      end

      it 'was removed from Column' do
        expect{ dataset.destroy }.to change(Column, :count).by(-4)
      end
    end

    describe 'removing from Elasticsearch' do
      subject { dataset.destroy }

      it 'calls callback' do
        expect(dataset.__elasticsearch__).to receive(:delete_document)
        subject.run_callbacks(:commit)
      end

    end
  end

  describe 'country_name' do
    it  'sets the country name when there is a matching country code available' do
      dataset = create(:dataset, country_code: 'TT')

      expect(dataset.country_name).to eq 'Trinidad and Tobago'
    end

    it  "doesn't set the country name when there isn't a matching country code" do
      dataset = create(:dataset, country_code: 'doesnotexist')

      expect(dataset.country_name).to be_nil
    end

    it  "doesn't set the country name when country code is empty" do
      dataset = create(:dataset, country_code: '')

      expect(dataset.country_name).to be_nil
    end
  end

  describe 'calling Elasticsearch' do
    context 'without Dataset' do
      it 'when Dataset created' do
        dataset = create(:dataset)

        dataset.run_callbacks(:commit)
        expect(IndexDatasetWorker).to have_enqueued_job(dataset.id)
      end
    end

    context 'with existing Dataset' do
      let(:dataset) { create(:dataset) }
      let(:user) { create :user }

      it 'when Dataset updated' do
        dataset.name = Faker::Lorem.word
        dataset.save

        dataset.run_callbacks(:commit)
        expect(IndexDatasetWorker).to have_enqueued_job(dataset.id)
      end

      it 'when Dataset updated' do
        dataset.owner_id = user.id
        dataset.save

        dataset.run_callbacks(:commit)
        expect(IndexDatasetWorker).to have_enqueued_job(dataset.id)
      end

      it 'when Dataset destroyed' do
        dataset.destroy

        expect(dataset.__elasticsearch__).to receive(:delete_document).once
        dataset.run_callbacks(:commit)
      end
    end
  end

  context 'with notes' do
    let!(:dataset) { create(:dataset) }
    let!(:user) { create(:user) }
    let!(:note1) { create(:note, dataset: dataset, user: user) }
    let!(:note2) { create(:note, dataset: dataset, user: user) }
    before { dataset.reload }

    it "orders them chronologically from newest to oldest" do
      expect(dataset.notes.by_newest).to eq([note2, note1])
    end
  end
end
