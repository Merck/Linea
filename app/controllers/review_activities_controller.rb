# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class ReviewActivitiesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @review_activities = ReviewActivity.all
  end

  def show
    @review_activity = review_activity
  end

  def new
    @review_activity = ReviewActivity.new
  end

  def edit
    @review_activity = review_activity
  end

  def create
    @review_activity = ReviewActivity.new(review_activity_params)
    @review_activity.save!
    flash[:info] = 'Review was successfully created.'
    redirect_to @review_activity.dataset
  end

  def update
    review_activity.update!(review_activity_params)
    respond_with review_activity
  end

  def destroy
    dataset = review_activity.dataset
    review_activity.destroy!
    redirect_to dataset, notice: 'Review was successfully deleted.'
  end

  private

  def review_activity
    @review_activity ||= ReviewActivity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def review_activity_params
    params.require(:review_activity).permit(:user_id, :dataset_id, :review, :rating)
  end
end
