# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class SubjectAreasController < ApplicationController
  before_filter :authenticate_admin
  respond_to :html, :xml, :json

  def index
    @subject_areas = SubjectArea.all
  end

  def show
    @subject_area = subject_area
  end

  def new
    @subject_area = SubjectArea.new
  end

  def edit
    @subject_area = subject_area
  end

  def create
    @subject_area = SubjectArea.new(subject_area_params)
    @subject_area.save!
    respond_with @subject_area
  end

  def update
    subject_area.update!(subject_area_params)
    respond_with subject_area
  end

  def destroy
    subject_area.destroy!
    respond_with subject_area
  end

  private

  def subject_area
    @subject_area ||= SubjectArea.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def subject_area_params
    params.require(:subject_area).permit(:name, :description)
  end
end
