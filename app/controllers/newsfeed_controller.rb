# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class NewsfeedController < ApplicationController
  before_action :load_news_feed_items, only: [:index, :load_more]

  NEWSFEED_ITEMS_PER_LOAD = 10

  def index
    @newsfeed_items_per_load = NEWSFEED_ITEMS_PER_LOAD

    render
  end

  def load_more
    render partial: 'newsfeed_items'
  end

  private

  def load_news_feed_items
    @offset = 0
    params_offset
    params_users
    params_subject_area
    params_datasource
    params_tags

    if @selected_subject_area || @selected_datasource
      @newsfeed_items = dataset_joins
    else
      @newsfeed_items = dataset_where
    end
  end

  def conditions
    @conditions ||= {}
  end

  def params_users
    return unless params['users']
    conditions[:user_id] = params['users']
    @selected_users = params['users']
  end

  def params_subject_area
    return unless params['subject_area']
    conditions[:datasets] = { subject_area_id: params['subject_area'] }
    @selected_subject_area = params['subject_area']
  end

  def params_datasource
    return unless params['datasource']
    conditions[:datasets] = { datasource_id: params['datasource'] }
    @selected_datasource = params['datasource']
  end

  def params_tags
    return unless params['tags']
    # tags is dirty - we are gonna grap all the relevant dataset id's real quick and use that as a filter
    conditions[:dataset_id] = DatasetTag.select(:dataset_id).where(tag_id: params['tags'])
    @selected_tags = params['tags']
  end

  def params_offset
    return unless params['offset']
    @offset = params['offset'].to_i
  end

  def dataset_joins
    ni = NewsfeedItem.joins(:dataset).where(conditions).preload(:user)
      .preload(:dataset).limit(NEWSFEED_ITEMS_PER_LOAD).offset(@offset)

    ni.where.not(user_id: current_user.id) if logged_in?

    ni
  end

  def dataset_where
    ni = NewsfeedItem.where(conditions).preload(:user).preload(:dataset)
      .limit(NEWSFEED_ITEMS_PER_LOAD).offset(@offset)

    ni.where.not(user_id: current_user.id) if logged_in?

    ni
  end
end
