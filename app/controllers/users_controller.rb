# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class UsersController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_admin, except: [:mydatasets]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :update_name]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update_name
    @user.full_name = 'Santa'
    @user.save

    redirect_to get_popular_users_users_url
  end

  def show_number_if_any(collection)
    return " (#{collection.length})" unless collection.empty?
    ""
  end

  def mydatasets
    @my_datasets = policy_scope(Dataset)
    @my_datasets.sort! { |a, b| b.updated_at <=> a.updated_at }
    grouped_datasets = @my_datasets.group_by { |dataset| dataset.owner_id == current_user.id }
    @owned_datasets = grouped_datasets[true] || []
    @admin_datasets = grouped_datasets[false] || []
    @pending_requests = RequestAccess.where(owner_id: current_user.id).where(status: 0)
    @closed_requests = RequestAccess.where(owner_id: current_user.id).where(status: [1, 2])

    @fav_datasets = LikeActivity.where(user: current_user).order('created_at').collect(&:dataset)
    @my_datasets_title = "MY DATASETS" + show_number_if_any(@my_datasets)
    @fav_datasets_title = "FAVORITE DATASETS" + show_number_if_any(@fav_datasets)
    @requests_title = "REQUESTS" + show_number_if_any(@pending_requests)
    render :mydatasets
  end

  def create
    @user = User.new(user_params)
    @user.save!
    respond_with @user
  end

  def update
    @user.update!(user_params)
    respond_with @user
  end

  def destroy
    @user.destroy!
    respond_with @user
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:id, :username, :full_name, :is_admin, :subject_area_id,
                                 :address, :country, :country_code, :department, :email,
                                 :full_name, :first_name, :location, :manager, :state,
                                 :title, :postal_code, :region)
  end
end
