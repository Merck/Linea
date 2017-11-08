# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class DatasourcesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @datasources = Datasource.all
  end

  def show
    @datasource = datasource
  end

  def new
    @datasource = Datasource.new
  end

  def edit
    @datasource = datasource
  end

  def create
    @datasource = Datasource.new(datasource_params)
    @datasource.save!
    respond_with @datasource
  end

  def update
    datasource.update!(datasource_params)
    respond_with datasource
  end

  def destroy
    datasource.destroy!
    respond_with datasource
  end

  private

  def datasource
    @datasource ||= Datasource.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def datasource_params
    params.require(:datasource).permit(:name)
  end
end
