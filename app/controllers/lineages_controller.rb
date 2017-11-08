# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class LineagesController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_admin, except: [:details]

  def index
    @lineages = Lineage.all
  end

  def show
    @lineage = lineage
  end

  def details
    @lineage = lineage
    render partial: 'details'
  end

  def new
    @lineage = Lineage.new
  end

  def edit
    @lineage = lineage
  end

  def create
    @lineage = Lineage.new(lineage_params)
    @lineage.save!
    respond_with @lineage
  end

  def update
    lineage.update!(lineage_params)
    respond_with lineage
  end

  def destroy
    lineage.destroy!
    respond_with lineage
  end

  private

  def lineage
    @lineage ||= Lineage.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def lineage_params
    params.require(:lineage).permit(:child_dataset_id, :parent_dataset_id, :operation, :comment)
  end
end
