# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class SearchActivitiesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @search_activities = SearchActivity.all
  end

  def show
    @search_activity = search_activity
  end

  def new
    @search_activity = SearchActivity.new
  end

  def edit
    @search_activity = search_activity
  end

  def create
    @search_activity = SearchActivity.new(search_activity_params)
    @search_activity.save!
    respond_with @search_activity
  end

  def update
    search_activity.update!(search_activity_params)
    respond_with search_activity
  end

  def destroy
    search_activity.destroy!
    respond_with search_activity
  end

  private

  def search_activity
    @search_activity ||= SearchActivity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def search_activity_params
    params.require(:search_activity).permit(:user_id, :search_terms)
  end
end
