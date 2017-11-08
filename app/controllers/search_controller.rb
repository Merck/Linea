# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class SearchController < ApplicationController
  RESULTS_PER_PAGE = 10

  DATASET_SEARCH_FIELDS = %w(
    name^10
    description^2
    owner.full_name^2
    subject_area.name
    country_code
    country_name
    datasources.name
    tags.name^2
    tables.name
    columns.name
    columns.business_name
    dataset_attributes.key
    dataset_attributes.value^3
    dataset_attributes.comment
  )

  def search
    @search_duration = 0

    # Expose the selected facets to the view, so they can remain checked.
    @selected_tags = (params['tags'] || []).map(&:to_i)
    @selected_owner = (params['owner'] || []).map(&:to_i)
    @selected_subject_area = (params['subject_area'] || []).map(&:to_i)
    @selected_country_codes = params['country_code']

    search_result = perform_search
    @search_duration += search_result.took
    @total_results = search_result.results.total

    aggregations_result = perform_aggregations_search
    @search_duration += aggregations_result.took

    @tags, @tags_count = build_facet(aggregations_result, :tags, Tag)
    @subject_areas, @subject_areas_count = build_facet(aggregations_result, :subject_area, SubjectArea)
    @owners, @owners_count = build_facet(aggregations_result, :owner, User)
    @countries, @countries_count = build_country_facet(aggregations_result, :country_code)

    @datasets = search_result.records
  rescue Exception
    @datasets = []
  end

  def autocomplete
    render json: fetch_suggestions, root: false
  end

  def related_tags
    aggregation = { tags: { terms: { field: :"tags.id" } } }
    build_related_search(aggregation, 'tags')
  end

  def related_people
    aggregation = { owner: { terms: { field: :"owner.id" } } }
    build_related_search(aggregation, 'owner')
  end

  private

  def query
    @query ||= params.fetch('query', '')
  end

  def perform_search
    payload = {
      query: {
        filtered: build_query_params
      },
      highlight: {
        pre_tags: ["<mark>"],
        post_tags: ["</mark>"],
        fields: {
          name: {},
          description: {number_of_fragments: 0}
        }
      }
    }
    logger.info("Search query:\n#{payload.to_json}")

    Dataset.search(payload).paginate(page: params[:page], per_page: RESULTS_PER_PAGE)
  end

  def perform_aggregations_search
    payload = {
      query: build_aggregation_query_params,
      aggs: dataset_aggregations
    }

    logger.info("Aggregations query:\n#{payload.to_json}")

    Dataset.search(payload)
  end

  def dataset_aggregations
    {
      tags: {
        terms: {
          field: "tags.id",
          size: 0
        }
      },
      subject_area: {
        terms: {
          field: "subject_area.id",
          size: 0
        }
      },
      owner: {
        terms: {
          field: "owner.id",
          size: 0
        }
      },
      country_code: {
        terms: {
          field: "country_code",
          size: 0
        }
      }
    }
  end

  def build_facet(aggregations_result, filter, model)
    entity_ids = []
    entities_count = {}

    aggregations_result.aggregations[filter]['buckets'].each do |bucket|
      entity_ids << bucket['key']
      entities_count[bucket['key'].to_i] = bucket['doc_count']
    end

    entities = model.find(entity_ids)
    entities.sort! { |a, b| entities_count[b.id] <=> entities_count[a.id] }

    [entities, entities_count]
  end

  def build_country_facet(aggregations_result, filter)
    entity_ids = []
    entities_count = {}

    aggregations_result.aggregations[filter]['buckets'].each do |bucket|
      entity_ids << bucket['key']
      entities_count[bucket['key']] = bucket['doc_count']
    end

    entities = Dataset.where(country_code: entity_ids.map(&:upcase)).uniq.pluck(:country_code).to_a
    entities.sort! { |a, b| entities_count[b] <=> entities_count[a] }

    [entities, entities_count]
  end

  # Builds the filtered query parameters for the main elastic search.
  # Will NOT include the "query" field if NO query was provided (ex. only filtering by 'tags')
  def build_query_params
    query_params = { filter: generate_filter(params) }
    query_params[:query] = dis_max_query if query.present?

    query_params
  end

  def build_aggregation_query_params
    query_params = {}

    if query.present?
      query_params[:dis_max] = dis_max_query[:dis_max]
    else
      query_params[:match_all] = {}
    end

    query_params
  end

  def dis_max_query
    dis_max = {
      dis_max: {
        tie_breaker: 0.3,
        queries:  [
          {
            bool: {
              should: [
                {
                  match_phrase: {
                    name: {
                      query: query,
                      slop: 50
                    }
                  }
                },
                {
                  match: {
                    'name.shingles': query
                  }
                },
                {
                  match: {
                    name: query
                  }
                },
                {
                  wildcard: { name: query }
                }
              ],
              boost: extract_boost(DATASET_SEARCH_FIELDS.first).last,
              minimum_should_match: "25%"
            }
          }
        ]
      }
    }
    DATASET_SEARCH_FIELDS[1..-1].each do |field|
      field_name, boost = extract_boost(field)
      logger.info "#{field_name} => #{boost} -> #{query}"
      logger.info "dis: #{dis_max.inspect}"
      dis_max[:dis_max][:queries] << {
        bool: {
          should: [
            {
              match_phrase: {
                "#{field_name}" => {
                  query: query,
                  slop: 50
                }
              }
            },
            {
              match: {
                "#{field_name}" => query
              }
            },
            {
              wildcard: { "#{field_name}" => query }
            }
          ],
          boost: boost,
          minimum_should_match: "33%"
        }
      }
    end

    dis_max[:dis_max][:queries] << {
      multi_match: {
        query: query,
        type: 'cross_fields',
        fields: ['name^2', 'description', 'dataset_attributes.value']
      }
    }

    dis_max
  end

  def extract_boost(field)
    field_parts = field.split('^')
    field_name = field_parts.first
    boost = field_parts.size == 2 ? field_parts.last : 1

    [field_name, boost]
  end

  def generate_filter(params, fields = %w(tags subject_area owner country_code))
    filters = []

    fields.each do |f|
      if params[f].present?
        filters << (f == 'country_code' ? { terms: { "#{f}" => params[f] } } : { terms: { "#{f}.id" => params[f] } })
      end
    end

    if filters.empty?
      return {}
    elsif filters.length == 1
      return filters.first
    else
      return { and: filters }
    end
  end

  def scale_tags_for_cloud(tags)
    min_font = 20
    max_font = 60

    counts = tags.collect { |t| t[:size] }

    min_count = counts.min
    max_count = counts.max

    ratio = 1
    ratio = (max_font - min_font) / (max_count - min_count) unless max_count - min_count == 0

    tags.each do |t|
      t[:size] = (t[:size] - min_count) * ratio + min_font
    end

    tags
  end

  def fetch_suggestions
    SearchService.autocomplete(
      query: params.fetch('q', ''),
      fields: %w(name owner_name tag)
    )
  end

  def build_related_search(agg, filter)
    raw_search_result = Dataset.search(query: {
                                         multi_match: {
                                           query: query,
                                           fields: DATASET_SEARCH_FIELDS
                                         }
                                       },
                                       aggs: agg
                                      )

    @search_duration = raw_search_result.took
    @total_results = raw_search_result.results.total

    @tags = []

    if raw_search_result.aggregations
      raw_search_result.aggregations[filter]['buckets'].each do |b|
        case filter
        when 'tags'
          @tags << { text: Tag.find(b['key']).name, size: b['doc_count'] }
        when 'owner'
          @tags << { text: User.find(b['key']).full_name, size: b['doc_count'] }
        end
      end
    end

    @tags = scale_tags_for_cloud(@tags)
  end
end
