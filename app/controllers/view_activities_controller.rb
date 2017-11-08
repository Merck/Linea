# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class ViewActivitiesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @view_activities = ViewActivity.all
  end

  def show
    @view_activity = view_activity
  end

  def new
    @view_activity = ViewActivity.new
  end

  def edit
    @view_activity = view_activity
  end

  def create
    @view_activity = ViewActivity.new(view_activity_params)
    @view_activity.save!
    respond_with @view_activity
  end

  def update
    view_activity.update!(view_activity_params)
    respond_with view_activity
  end

  def destroy
    view_activity.destroy!
    respond_with view_activity
  end

  private

  def view_activity
    @view_activity ||= ViewActivity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def view_activity_params
    params.require(:view_activity).permit(:dataset_id, :user_id)
  end
end
