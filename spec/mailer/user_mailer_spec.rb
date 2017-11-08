# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

describe UserMailer do

  describe '#notify_user_about_dataset_removal' do
    let(:user) { create(:user, email: 'owner@company.com') }
    let(:dataset) { create(:dataset, owner_id: user.id) }
    let(:applicant) { create(:user, email: 'applicant@company.com') }

    let(:request_access) do
      create(
        :request_access,
        owner_id: user.id,
        user: applicant,
        dataset: dataset,
        status: :approved
      )
    end

    let(:mail_subject) { "Linea dataset removed: (#{dataset.name})" }

    let(:mail) do
      UserMailer.notify_user_about_dataset_removal(request_access, dataset)
    end

    it 'sends the email' do
      ActionMailer::Base.deliveries = []

      mail.deliver_now

      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'renders the subject' do
      expect(mail.subject.to_s).to eq(mail_subject)
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.full_name)
      expect(mail.body.encoded).to match(dataset.name)
      expect(mail.body.encoded).to match(user.full_name)
    end
  end
end