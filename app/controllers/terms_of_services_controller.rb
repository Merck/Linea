# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class TermsOfServicesController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_admin

  before_action :set_terms_of_service, only: [:show, :edit, :update, :destroy]

  def index
    @terms_of_services = TermsOfService.all
  end

  def show
  end

  def new
    @terms_of_service = TermsOfService.new
  end

  def edit
  end

  def create
    @terms_of_service = TermsOfService.new(terms_of_service_params)
    @terms_of_service.save!
    respond_with @terms_of_service
  end

  def update
    @terms_of_service.update!(terms_of_service_params)
    respond_with @terms_of_service
  end

  def destroy
    @terms_of_service.destroy!
    respond_with @terms_of_service
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_terms_of_service
    @terms_of_service = TermsOfService.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def terms_of_service_params
    params.require(:terms_of_service).permit(:name, :description)
  end
end
