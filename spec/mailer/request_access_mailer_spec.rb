# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

RSpec.describe RequestAccessMailer do
  let(:request_access) do
    user = create(:user, email: 'owner@company.com')
    applicant = create(:user, email: 'applicant@company.com')
    dataset = create(:dataset, owner_id: user.id)

    create(
      :request_access,
      owner_id: user.id,
      user_id: applicant.id,
      dataset: dataset
    )
  end

  describe 'notify dataset owner' do
    let(:subject) do
      subject = "User #{request_access.applicant_full_name} "
      subject << 'asking for granting access to '
      subject << "dataset #{request_access.dataset_name}"
      subject
    end

    let(:mail) do
      RequestAccessMailer.notify_owner(data: request_access, subject: subject)
    end

    it 'send email' do
      ActionMailer::Base.deliveries = []

      mail.deliver_now

      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'renders the subject' do
      expect(mail.subject.to_s).to eq(
        subject
      )
    end

    it 'renders the recipient' do
      expect(mail.to.first).to eq(request_access.owner_email)
    end

    it 'renders the sender email' do
      expect(mail.from.first).to eq('notification@app.company.com')
    end

    it 'assigner @request_access' do
      expect(mail.body.encoded).to include('grant or deny')
    end
  end

  describe 'notify applicant about granted access' do
    let(:subject) do
      subject = "The owner #{request_access.owner.full_name} "
      subject << 'has granted you access to required '
      subject << "dataset #{request_access.dataset_name}."
      subject
    end

    let(:mail) do
      RequestAccessMailer.access_granted(data: request_access, subject: subject)
    end

    it 'send email' do
      ActionMailer::Base.deliveries = []

      mail.deliver_now

      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'renders the subject' do
      expect(mail.subject.to_s).to eq(
        subject
      )
    end

    it 'renders the recipient' do
      expect(mail.to.first).to eq(request_access.applicant_email)
    end

    it 'renders the sender email' do
      expect(mail.from.first).to eq(Rails.application.config.support_email)
    end

    it 'assigner @request_access' do
      expect(mail.body.encoded).to include('sent')
    end
  end

  describe 'notify applicant about rejected access' do
    let(:subject) do
      subject = "The owner #{request_access.owner.full_name} "
      subject << 'has denied you access to required '
      subject << "dataset #{request_access.dataset_name}."
      subject
    end

    let(:mail) do
      RequestAccessMailer.access_denied(data: request_access, subject: subject)
    end

    it 'send email' do
      ActionMailer::Base.deliveries = []

      mail.deliver_now

      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'renders the subject' do
      expect(mail.subject.to_s).to eq(
        subject
      )
    end

    it 'renders the recipient' do
      expect(mail.to.first).to eq(request_access.applicant_email)
    end

    it 'renders the sender email' do
      expect(mail.from.first).to eq('notification@app.company.com')
    end

    it 'assigner @request_access' do
      expect(mail.body.encoded).to include('was declined')
    end
  end
end
