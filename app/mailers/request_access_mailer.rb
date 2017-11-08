# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class RequestAccessMailer < ApplicationMailer
  default from: 'notification@support.company.com' #place your actual default support email here

  def notify_owner(data:, subject:)
    @request_access = data
    @dataset = @request_access.dataset
    @owner = @request_access.owner
    @user = @request_access.user
    @owner_dashboard_url = dataset_request_accesses_url(id: @dataset.id)

    data.update_attribute(:emailed_owner_at, Time.now)

    mail to: @request_access.owner_email, subject: subject, reply_to: @user.email
  end

  def access_granted(data:, subject:)
    @request_access = data
    @dataset = @request_access.dataset
    @user = @request_access.user
    @dataset_url = dataset_url(id: @dataset.id)

    data.update_attribute(:emailed_user_at, Time.now)

    mail from: "Linea team <#{Rails.application.config.support_email}>", to: @request_access.applicant_email, subject: subject
  end

  def access_denied(data:, subject:)
    @request_access = data
    @dataset = @request_access.dataset
    @user = @request_access.user

    data.update_attribute(:emailed_user_at, Time.now)

    mail to: @request_access.applicant_email, subject: subject
  end
end
