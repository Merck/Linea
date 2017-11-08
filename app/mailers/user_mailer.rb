# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class UserMailer < ApplicationMailer
  default from: 'notification@application.company.com' #place your default notification email here

  def notify_user_about_dataset_removal(request_access, dataset)
    @dataset = dataset
    @user = request_access.user
    @owner = request_access.owner
    subject = "Linea dataset removed: (#{@dataset.name})"

    request_access.update_attribute(:emailed_user_at, Time.now)

    mail to: @user.email, subject: subject
  end
end
