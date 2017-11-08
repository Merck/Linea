# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class DatasetVisualToolsController < ApplicationController
  before_filter :authenticate_user

  def index
    @dataset_visual_tools = DatasetVisualTool.all
  end

  def show
    @dataset_visual_tool = dataset_visual_tool
  end

  def new
    @dataset_visual_tool = DatasetVisualTool.new
  end

  def edit
    @dataset_visual_tool = dataset_visual_tool
  end

  def create
    @dataset_visual_tool = DatasetVisualTool.new(dataset_visual_tool_params)
    @dataset_visual_tool.save!
    respond_with @dataset_visual_tool
  end

  def update
    dataset_visual_tool.update!(dataset_visual_tool_params)
    respond_with dataset_visual_tool
  end

  def destroy
    dataset_visual_tool.destroy!
    respond_with dataset_visual_tool
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def dataset_visual_tool
    @dataset_visual_tool ||= DatasetVisualTool.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dataset_visual_tool_params
    params.require(:dataset_visual_tool).permit(:name, :dataset_id)
  end
end
