# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class LikeActivitiesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @like_activities = LikeActivity.all
  end

  def show
    @like_activity = like_activity
  end

  def new
    @like_activity = LikeActivity.new
  end

  def edit
    @like_activity = like_activity
  end

  def create
    @like_activity = LikeActivity.new(like_activity_params)
    @like_activity.save!
    respond_with @like_activity
  end

  def update
    like_activity.update!(like_activity_params)
    respond_with like_activity
  end

  def destroy
    like_activity.destroy!
    respond_with like_activity
  end

  private

  def like_activity
    @like_activity ||= LikeActivity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def like_activity_params
    params.require(:like_activity).permit(:dataset_id, :user_id)
  end
end
