# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class ColumnsController < ApplicationController
  # before_filter :authenticate_admin, except: [:show]
  respond_to :html, :xml, :json

  def index
    @columns = Column.all
  end

  def show
    @column = column
  end

  def new
    @column = Column.new
  end

  def edit
    @column = column
  end

  def create
    @column = Column.new(column_params)
    @column.save!
    respond_with @column
  end

  def update
    column.update!(column_params)
    respond_with column
  end

  def destroy
    @column = Column.find(params[:id])
    @column.destroy

    respond_to do |format|
      format.js {}
    end
  end

  private

  def column
    @column ||= Column.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def column_params
    params.require(:column).permit(:dataset_id, :name, :description, :data_type, :business_name, :is_business_key, :table_id)
  end
end
