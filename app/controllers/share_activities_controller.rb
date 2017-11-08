# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class ShareActivitiesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :set_share_activity, only: [:show, :edit, :update, :destroy]

  def index
    @share_activities = ShareActivity.all
  end

  def show
  end

  def new
    @share_activity = ShareActivity.new
  end

  def edit
  end

  def create
    @share_activity = ShareActivity.new(share_activity_params)
    @share_activity.save!
    respond_with @share_activity
  end

  def update
    @share_activity.update!(share_activity_params)
    respond_with @share_activity
  end

  def destroy
    @share_activity.destroy!
    respond_with @share_activity
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_share_activity
    @share_activity = ShareActivity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def share_activity_params
    params.require(:share_activity).permit(:dataset_id, :user_id, :comment)
  end
end
