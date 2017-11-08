# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class MyDatasetsController < TransformationBaseEditingController
  respond_to :html

  def new
    @dataset = Dataset.new
    @dataset_scheduling = DatasetScheduling.default_instance
    assign_objects_for_new_form
  end

  def create
    dataset_params = dataset_params_for_catalog_create
    dataset_params[:tag_ids] = Tag.proceed_tags(dataset_params[:tag_ids])

    @dataset = Dataset.new(dataset_params)
    @terms_of_service_item = TermsOfService.create(name: dataset_params[:terms_of_service_name])
    @dataset.terms_of_service = @terms_of_service_item
    if @dataset.save
      flash[:dataset_id] = @dataset.id
      redirect_to mydatasets_url, notice: 'Dataset was successfully created.'
      logger.info "Dataset created by user #{current_user.username} (#{current_user.id}) on #{DateTime.now}: \
        #{@dataset.attributes.except(:description)}"
    else
      render :new
    end
  end

  def edit
    @dataset = find_dataset(params[:id])
    authorize @dataset, :edit?
  end

  def update
    @dataset = find_dataset(params[:id])
    authorize @dataset, :edit?

    dataset_params = dataset_params_for_update
    dataset_params[:tag_ids] = Tag.proceed_tags(dataset_params[:tag_ids])

    @dataset.update_attributes(dataset_params)
    redirect_to @dataset, notice: 'Dataset was successfully updated.'
    logger.info "Dataset updated by user #{current_user.username} (#{current_user.id}) on #{DateTime.now}: \
      #{@dataset.previous_changes}"
  end

  def destroy
    @dataset = find_dataset(params[:id])
    authorize @dataset, :destroy?

    begin
      ActiveRecord::Base.transaction do
        approved_accesses = get_approved_accesses
        notify_users_with_approved_access_about_dataset_removal(approved_accesses)
        @dataset.destroy!
      end
    rescue StandardError => e
      logger.error("Error removing Dataset: #{e.class} (#{e.message})")
      flash[:error] = 'Dataset could not be removed because of an error'

      if request.xhr?
        flash.keep(:error)
        head :unprocessable_entity and return
      else
        redirect_to mydatasets_url
      end
    end

    flash[:notice] = 'Dataset removed'
    logger.info("Dataset removed (Dataset: #{@dataset.id} #{@dataset.name}), \
      User: #{current_user.full_name}, #{current_user.email}")

    if request.xhr?
      flash.keep(:notice)
      head :ok and return
    else
      redirect_to mydatasets_url
    end
  end

  def template_for_initial_scenario
    @dataset = find_dataset(params[:id])

    render partial: 'my_datasets/remove_dataset/initial_scenario'
  end

  def check_on_status
    @dataset = find_dataset(params[:id])

    # A/ Linea only datasets
    unless @dataset.external_id
      # This dataset has no dependent datasets. It exists in Linea catalog only
      render partial: 'my_datasets/remove_dataset/scenario_1' and return
    end

    # B/ Linea & MG datasets
    begin
      approved_accesses = get_approved_accesses

      if approved_accesses.any?
        render partial: 'my_datasets/remove_dataset/scenario_3', locals: {
            approved_accesses: approved_accesses} and return
      else
        # There are no approved accesses)
        render partial: 'my_datasets/remove_dataset/scenario_1' and return
      end
    rescue Rest::ClientError => e
      logger.error("Error checking on Dataset status: #{e.class} (#{e.message}):\n#{e.response}")
      render partial: 'my_datasets/remove_dataset/scenario_4' and return
    end

    # C/ Any other edge case
    logger.error("Error checking on dataset status. Dataset: #{@dataset}")
    render partial: 'my_datasets/remove_dataset/scenario_4' and return
  end

  private

  def notify_users_with_approved_access_about_dataset_removal(approved_accesses)
    approved_accesses.each do |access|
      UserMailer.notify_user_about_dataset_removal(access, @dataset).deliver_now
    end
  end

  def get_approved_accesses
    @approved_accesses ||= RequestAccess.approved.where(dataset: @dataset)
  end

  def dataset_params_for_catalog_create
    params.require(:dataset).permit(
      :name, :domain, :description, :url, :terms_of_service_name,
      :subject_area_id, :restricted, :datasource_id, :country_code,
      tag_ids: [], algorithm_ids: []
    ).merge(owner_id: current_user.id)
  end

  def dataset_params_for_update
    params.require(:dataset).permit(
      :name,
      :description,
      :url,
      :terms_of_service_name,
      :subject_area_id,
      :restricted,
      :country_code,
      tag_ids: []
    )
  end
end
