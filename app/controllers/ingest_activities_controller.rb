# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class IngestActivitiesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @ingest_activities = IngestActivity.all
  end

  def show
    @ingest_activity = ingest_activity
  end

  def new
    @ingest_activity = IngestActivity.new
  end

  def edit
    @ingest_activity = ingest_activity
  end

  def create
    @ingest_activity = IngestActivity.new(ingest_activity_params)
    @ingest_activity.save!
    respond_with @ingest_activity
  end

  def update
    ingest_activity.update!(ingest_activity_params)
    respond_with ingest_activity
  end

  def destroy
    ingest_activity.destroy!
    respond_with ingest_activity
  end

  private

  def ingest_activity
    @ingest_activity ||= IngestActivity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ingest_activity_params
    params.require(:ingest_activity).permit(:dataset_id, :user_id, :comment)
  end
end
