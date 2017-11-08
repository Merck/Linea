# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class TransformationBaseEditingController < ApplicationController
  private

  def assign_objects_for_new_form(options: {})
    @my_datasets = policy_scope(Dataset)
    @available_clusters = []
    @retention_policy = [{'name' => 'hours'}, {'name' => 'days'}, {'name' => 'months'}]
  end

  def dataset_scheduling_params
    params.require(:dataset_scheduling).permit(
      :type,
      :job,
      :frequency,
      :start_date
    )
  end

  def find_dataset(dataset_id)
    Dataset.find_by!(id: dataset_id)
  end
end
