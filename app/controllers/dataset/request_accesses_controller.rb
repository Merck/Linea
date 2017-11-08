# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class Dataset::RequestAccessesController < DatasetsController
  respond_to :html, :xml, :json

  before_action :set_dataset, only: [:index, :create, :approve, :reject]
  before_action :ensure_dataset_owner, only: [:index, :approve, :reject]
  before_action :ensure_create_request_has_been_not_resolved, only: [:create]
  before_action :ensure_request_has_been_not_resolved, only: [:approve, :reject]

  def index
    @request_accesses = @dataset.request_accesses.order(:status, :created_at).includes(:user)
  end

  # FIXME
  def create
    DatasetServices::RequestAccessService.new(request_access_params).initiate
    muted = params[:muted] || false
    notice = 'Request to access dataset has been sent to the owner'

    respond_with do |format|
      format.html do
        if request.xhr?
          flash.discard
          render json: notice
        else
          flash[:notice] = notice unless muted
          redirect_to(dataset_path(params[:id]))
        end
      end
    end
  end

  # FIXME
  def approve
    request_access_service = DatasetServices::RequestAccessService.new(request_access_params)
    if request_access_service
      request_access_service.approve
      if request_access_service.approved?
        notice = 'Access request was approved'
      else
        notice = 'Access request was not approved'
      end
      redirect_to(dataset_request_accesses_path(id: params[:id]), notice: notice)
    end
  end

  # FIXME
  def reject
    DatasetServices::RequestAccessService.new(request_access_params).deny

    redirect_to(
      dataset_request_accesses_path(
        id: params[:id]
      ),
      notice: 'Access request was rejected.'
    )
  end

  private

  def ensure_request_has_been_not_resolved
    policy = RequestAccessPolicy.new(current_user, params[:request_access_id])
    fail(t 'request_access_policy.resolved?', scope: 'pundit') if policy.resolved?
  end

  def ensure_create_request_has_been_not_resolved
    policy = DatasetPolicy.new(current_user, @dataset)
    fail(t 'request_access_policy.resolved?', scope: 'pundit') unless policy.can_request_access?
  end

  def request_access_params
    params.permit(:request_access_id, :admin).merge(
      user_id: current_user.id,
      dataset_id: @dataset.id,
      owner_id: @dataset.owner_id
    )
  end
end
