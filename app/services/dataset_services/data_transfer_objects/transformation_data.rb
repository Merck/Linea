# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module DataTransferObjects
  class TransformationData
    attr_accessor :transformation_list, :transformation_instance, :type, :message, :error_message
    def initialize(message)
      @message = message
    end
  end

  class TransformationLogData
    attr_accessor :message, :action_list, :message, :transformation_instance, :active_log, :default_error_log, :default_system_log, :error_log_index, :system_log_index

    # def new(transformation_instance)
    #     obj = allocate
    #     obj.initialize(transformation_instance)
    #     obj
    # end

    def initialize(transformation_instance)
      @transformation_instance = transformation_instance
    end
  end

  class TransformationLogItem
    attr_accessor :log_name, :log_value, :message
    def initialize(message)
      @message = message
    end
  end

  class TransformationActionItem
    attr_accessor :action_name, :action_value, :status, :message, :transformation_log_items, :index
    def initialize(message)
      @message = message
    end
  end
end
