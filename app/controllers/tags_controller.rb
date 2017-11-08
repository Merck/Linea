# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class TagsController < ApplicationController
  before_filter :authenticate_admin, except: [:autocomplete, :popular]
  respond_to :html, :xml, :json

  def index
    @tags = Tag.all
  end

  def show
    @tag = tag
    @lineages = {}
  end

  def new
    @tag = Tag.new
  end

  def edit
    @tag = tag
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.save!
    respond_with @tag
  end

  def update
    tag.update!(tag_params)
    respond_with tag
  end

  def destroy
    tag.destroy!
    respond_with tag
  end

  def autocomplete
    render json: fetch_suggestions, root: false
  end

  def popular
    tags = DatasetTag.joins(:tag).select('tag_id, tags.name as text, count(dataset_tags.id) as size')
           .group('tag_id, text').order('size DESC').limit(20)
    render json: tags, root: false
  end

  private

  def fetch_suggestions
    SearchService.autocomplete(
      query: params.fetch('q', ''),
      fields: ['tag']
    )
  end

  def tag
    @tag ||= Tag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:name, :created_by_id)
  end
end
