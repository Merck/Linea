# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class DatasetAlgorithmsController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @dataset_algorithms = DatasetAlgorithm.all
  end

  def show
    @dataset_algorithm = dataset_algorithm
  end

  def new
    @dataset_algorithm = DatasetAlgorithm.new
  end

  def edit
    @dataset_algorithm = dataset_algorithm
  end

  def create
    @dataset_algorithm = DatasetAlgorithm.new(dataset_algorithm_params)
    @dataset_algorithm.save!
    respond_with @dataset_algorithm
  end

  def update
    dataset_algorithm.update!(dataset_algorithm_params)
    respond_with dataset_algorithm
  end

  def destroy
    dataset_algorithm.destroy!
    respond_with dataset_algorithm
  end

  private

  def dataset_algorithm
    @dataset_algorithm ||= DatasetAlgorithm.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dataset_algorithm_params
    params.require(:dataset_algorithm).permit(:dataset_id, :algorithm_id)
  end
end
