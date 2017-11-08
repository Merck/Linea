# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class DatasetService
  class << self
    def create(dataset:, transformation:, scheduling:, user:)
      dataset.transaction do
        return false unless dataset.valid?#[, transformation.valid?, scheduling.valid?].all?
        dataset.save!
        true
      end

    rescue Rest::ClientError => exc
      unless handle_middlegate_error(response: exc.response, dataset: dataset)
        Rails.logger.warn("#{exc.class} (#{exc.message}):\n#{exc.response}")
        dataset.update(middlegate_type: nil)
        fail
      end
      false
    end

    def update(dataset:, dataset_params:, user:, scheduling: nil)
      ActiveRecord::Base.transaction do
        return false unless dataset.update(dataset_params)
      end
      true
    end

    private

    def forbidden_combination?(dataset, transformation)
      false # BDP-829
    end

    def forbidden_combinations
      {HDFS: ['JDBC', 'HIVE'],
       HIVE: ['URI', 'DISTCP']}
    end

    # Returns true if the error is handled,
    # returns false if the error is unknown.
    def handle_middlegate_error(response:, dataset:)
      parsed_response_message = JSON.parse(response)['message']
      case parsed_response_message
      when /Only absolute paths allowed/
        dataset.errors.add(:hdfs_folder, 'Only absolute path allowed')

      when /Path.*is already used/
        dataset.errors.add(:hdfs_folder, 'Path is already used')

      when /Permission denied/
        dataset.errors.add(:hdfs_folder, "Permission denied")

      when /The hive database.*already exists/
        dataset.errors.add(:db_name, "This name is already used")

      when /Dataset with id.* not found/
        dataset.errors.add(:external_id, parsed_response_message)

      else
        return false
      end
      true

    rescue JSON::ParserError
      false
    end
  end
end
