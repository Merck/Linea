# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class AlgorithmsController < ApplicationController
  before_filter :authenticate_admin, except: [:show]
  respond_to :html, :xml, :json

  def index
    @algorithms = Algorithm.all
  end

  def show
    @algorithm = algorithm
  end

  def new
    @algorithm = Algorithm.new
  end

  def edit
    @algorithm = algorithm
  end

  def create
    @algorithm = Algorithm.new(algorithm_params)
    @algorithm.save!
    respond_with @algorithm
  end

  def update
    algorithm.update!(algorithm_params)
    respond_with algorithm
  end

  def destroy
    algorithm.destroy!
    respond_with algorithm
  end

  private

  def algorithm
    @algorithm ||= Algorithm.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def algorithm_params
    params.require(:algorithm).permit(:name, :path, :dataset_id)
  end
end
