# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class ContributorsController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @contributors = Contributor.all
  end

  def show
    @contributor = contributor
  end

  def new
    @contributor = Contributor.new
  end

  def edit
    @contributor = contributor
  end

  def create
    @contributor = Contributor.new(contributor_params)
    @contributor.save!
    respond_with @contributor
  end

  def update
    contributor.update!(contributor_params)
    respond_with contributor
  end

  def destroy
    contributor.destroy!
    respond_with contributor
  end

  private

  def contributor
    @contributor ||= Contributor.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contributor_params
    params.require(:contributor).permit(:dataset_id, :user_id)
  end
end
