# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class NotesController < ApplicationController
  before_action :set_dataset, only: [:edit, :create, :update, :destroy]
  before_action :set_note, only: [:edit, :update, :destroy]

  def edit
    authorize @note, :edit?
  end

  def create
    @note = @dataset.notes.new(note_params)
    authorize @note, :create?

    respond_to do |format|
      if @note.save
        format.js
      else
        format.js { render template: 'notes/error' }
      end
    end
  end

  def update
    authorize @note, :update?

    respond_to do |format|
      if @note.update(note_params)
        format.js
      else
        format.js { render json: { model: 'note', errors: @note.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @note, :destroy?
    @note.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def set_dataset
    @dataset ||= Dataset.find(params[:dataset_id])
  end

  def set_note
    @note ||= @dataset.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:dataset_id, :body).merge(user_id: current_user.id)
  end
end
