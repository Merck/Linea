# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'cron_validator'

class DatasetScheduling
  include ActiveModel::Model

  validate :instance_validations

  attr_accessor :type

  attr_accessor :job
  attr_accessor :frequency
  attr_writer :start_date

  (1..3).each do |i|
    define_method "start_date(#{i}i)=" do |v|
      @start_date_parts ||= []
      @start_date_parts[i - 1] = v
    end
  end

  def start_date
    return Time.new(*@start_date_parts).to_date if @start_date_parts.present?
    @start_date
  end

  def self.default_instance
    new(type: 'once')
  end

  private

  def instance_validations
    case type
    when 'once', 'every'
      # nothing to validate
    when 'cron'
      errors.add(:job, 'Invalid cron syntax') unless CronValidator.job_syntax_valid?(job)
    else
      fail 'Unknow scheduling type'
    end
  end
end
