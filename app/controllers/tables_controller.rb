# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class TablesController < ApplicationController
  before_action :set_dataset, only: [:edit, :create, :update, :destroy]
  before_action :set_table, only: [:edit, :update, :destroy]

  def edit
    @table = set_table
    @column = table.columns.find(params[:id])
  end

  def create
    # Query pundit to ensure user can edit the table of the specific dataset
    authorize @dataset, :edit?

    # If a table for the dataset already exists, add column to the existing table
    if table = Table.where(dataset_id: @dataset.id).first
      @table = table
      params[:table][:columns_attributes].each_value do |c|
        column_params = ActionController::Parameters.new(c)
        column_params.merge(table_id: @table.id)
        @table.columns.build(column_params.permit(:dataset_id, :name, :description, :data_type, :business_name, :is_business_key, :table_id))
      end
    # Otherwise, make a new table
    else
      @table = @dataset.tables.new(table_params)
    end

    respond_to do |format|
      if @table.save
        format.js
      else
        format.js { render template: 'tables/error' }
      end
    end
  end

  def new
    @table = set_table
  end

  def update
    authorize @table, :update?

    respond_to do |format|
      if @table.update(table_params)
        format.js
      else
        format.js { render json: { model: 'table', errors: @table.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @table, :destroy?
    @table.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def set_dataset
    @dataset ||= Dataset.find(params[:dataset_id])
  end

  def set_table
    @table ||= @dataset.tables.find(params[:id])
  end

  def table_params
    params.require(:table).permit(:name, columns_attributes: [:name, :description, :data_type, :business_name, :is_business_key, :table_id]).merge(dataset_id: @dataset.id)
  end
end
