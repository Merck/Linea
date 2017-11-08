# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class DatasetAttributesController < ApplicationController
  before_action :get_dataset
  before_action :get_dataset_attribute, only: [:edit, :update, :destroy]

  def new
    @dataset_attribute = @dataset.dataset_attributes.new
    authorize @dataset_attribute, :new?
  end

  def create
    @dataset_attribute = @dataset.dataset_attributes.new(attribute_params)
    authorize @dataset_attribute, :create?
    respond_to do |format|
      if @dataset_attribute.save
        format.js
      else
        format.js { render json: { model: 'dataset_attribute', errors: @dataset_attribute.errors }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @dataset_attribute, :edit?
  end

  def update
    authorize @dataset_attribute, :update?
    respond_to do |format|
      if @dataset_attribute.update(attribute_params)
        format.js
      else
        format.js { render json: { model: 'dataset_attribute', errors: @dataset_attribute.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @dataset_attribute, :destroy?
    @dataset_attribute.destroy
    respond_to do |format|
      format.js
    end
  end

  def autocomplete
    render json: DatasetAttribute.autocomplete(except: @dataset.id, query: params[:q]), root: false
  end

  private

  def get_dataset_attribute
    @dataset_attribute = @dataset.dataset_attributes.find(params[:id])
  end

  def attribute_params
    params.require(:dataset_attribute).permit(:key, :value, :comment)
  end

  def get_dataset
    @dataset = Dataset.find(params[:dataset_id])
  end
end
