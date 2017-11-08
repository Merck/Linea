# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class UserElasticsearchSolutionsController < ApplicationController
  respond_to :html

  def new
    authorize :navigation, :create_elasticsearch_solution?
    @user_elasticsearch_solution = UserElasticsearchSolution.new
    @my_datasets = policy_scope(Dataset)
    @dataset_scheduling = DatasetScheduling.new
    respond_with(@user_elasticsearch_solution)
  end

  def create
    authorize :navigation, :create_elasticsearch_solution?
    @user_elasticsearch_solution = UserElasticsearchSolutionService.new(
      current_user: current_user,
      params: user_elasticsearch_solution_params,
      scheduling_params: scheduling_params).initiate
    @my_datasets = policy_scope(Dataset)
    @dataset_scheduling = DatasetScheduling.new

    respond_with(
      @user_elasticsearch_solution,
      location: user_solutions_path
    )
  end

  def show
    @user_elasticsearch_solution = user_elasticsearch_solution
  end

  def edit
    @user_elasticsearch_solution = user_elasticsearch_solution
    authorize @user_elasticsearch_solution, :can_manage?
    @dataset_scheduling = DatasetScheduling.default_instance
  end

  def update
    authorize user_elasticsearch_solution, :can_manage?

    UserElasticsearchSolutionService.new(
      current_user: current_user,
      scheduling_params: scheduling_params,
      solution: user_elasticsearch_solution
    ).update

    respond_with(@user_elasticsearch_solution, location: user_solutions_path)
  end

  def destroy
    authorize user_elasticsearch_solution, :can_manage?

    UserElasticsearchSolutionService.new(
      current_user: current_user,
      solution: user_elasticsearch_solution
    ).delete

    user_elasticsearch_solution.destroy!

    respond_with(user_elasticsearch_solution, location: user_solutions_path)
  end

  private

  def user_elasticsearch_solution
    @user_elasticsearch_solution ||= UserElasticsearchSolution.find(params[:id])
  end

  def user_elasticsearch_solution_params
    params.require(:user_elasticsearch_solution).permit(
      :ip_address,
      :index_name,
      :host,
      :port,
      dataset_ids: []
    )
  end

  def scheduling_params
    params.require(:dataset_scheduling).permit(
      :type,
      :job,
      :frequency,
      :start_date
    )
  end
end
