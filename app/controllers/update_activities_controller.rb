# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class UpdateActivitiesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @update_activities = UpdateActivity.all
  end

  def show
    @update_activity = update_activity
  end

  def new
    @update_activity = UpdateActivity.new
  end

  def edit
    @update_activity = update_activity
  end

  def create
    @update_activity = UpdateActivity.new(update_activity_params)
    @update_activity.save!
    respond_with @update_activity
  end

  def update
    update_activity.update!(update_activity_params)
    respond_with update_activity
  end

  def destroy
    update_activity.destroy!
    respond_with update_activity
  end

  private

  def update_activity
    @update_activity ||= UpdateActivity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def update_activity_params
    params.require(:update_activity).permit(:user_id, :dataset_id, :comment)
  end
end
