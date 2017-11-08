# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module DatasetServices
  class RequestAccessService
    def initialize(params = {})
      @params = params
    end

    def initiate
      approve(send_notification: false)

      ActiveRecord::Base.transaction do
        request_access.save!
        mailer(
          delivery_method: :notify_owner,
          subject: "Linea dataset access request for #{request_access.dataset_name}"
        )
      end
    end

    def approve(send_notification: true)
      ActiveRecord::Base.transaction do
        request_access.approved!
        if params[:admin]
          request_access.admin!
        else
          request_access.user!
        end
        mailer(
          delivery_method: :access_granted,
          subject: "Linea dataset access request for #{request_access.dataset_name} approved"
        ) if send_notification
      end
    end

    def deny
      ActiveRecord::Base.transaction do
        request_access.rejected!
        mailer(
          delivery_method: :access_denied,
          subject: "Linea dataset access request for #{request_access.dataset_name} declined"
        )
      end
    end

    def approved?
      if @request_access
        @request_access.status == "approved"
      else
        false
      end
    end

    private

    attr_reader :params

    def mailer(delivery_method:, subject:)
      RequestAccessMailer.send(
        delivery_method, data: request_access, subject: subject
      ).deliver_now
    end

    def dataset
      @dataset ||= Dataset.find(params[:dataset_id])
    end

    def request_access
      @request_access ||= dataset.request_accesses.find_by(id: params[:request_access_id]) ||
                          dataset.request_accesses.build(user_id: params[:user_id], owner_id: params[:owner_id])
    end
  end
end
